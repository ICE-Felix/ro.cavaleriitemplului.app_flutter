# Shop Supabase Migration - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Migrate shop from WooCommerce to Supabase, simplify checkout to "comanda la bunicu" (email via Resend.io edge function), add order history in profile.

**Architecture:** Replace WooCommerce data layer with direct Supabase table queries (same pattern as news feature). Cart stays local in SharedPreferences. Orders stored in Supabase with edge function for email notification. New order history feature linked from profile.

**Tech Stack:** Flutter, Supabase SDK (direct queries), flutter_bloc, go_router, Supabase Edge Functions (Deno/TypeScript), Resend.io

---

### Task 1: Create Supabase database tables

**Files:**
- Create: `supabase/migrations/001_shop_tables.sql`

**Step 1: Write the migration SQL**

```sql
-- Shop categories
CREATE TABLE shop_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  image_url text,
  parent_id uuid REFERENCES shop_categories(id),
  sort_order integer DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Shop products
CREATE TABLE shop_products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  price numeric(10,2) NOT NULL,
  sale_price numeric(10,2),
  images jsonb DEFAULT '[]'::jsonb,
  category_id uuid REFERENCES shop_categories(id),
  is_active boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Shop orders
CREATE TABLE shop_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) NOT NULL,
  status text DEFAULT 'pending',
  note text,
  total numeric(10,2) NOT NULL,
  user_name text NOT NULL,
  user_email text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Shop order items
CREATE TABLE shop_order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES shop_orders(id) ON DELETE CASCADE NOT NULL,
  product_id uuid REFERENCES shop_products(id) NOT NULL,
  product_name text NOT NULL,
  product_price numeric(10,2) NOT NULL,
  quantity integer NOT NULL
);

-- Shop config (email addresses etc)
CREATE TABLE shop_config (
  key text PRIMARY KEY,
  value text NOT NULL
);

-- RLS policies
ALTER TABLE shop_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read active categories"
  ON shop_categories FOR SELECT TO authenticated
  USING (is_active = true);

CREATE POLICY "Authenticated users can read active products"
  ON shop_products FOR SELECT TO authenticated
  USING (is_active = true);

CREATE POLICY "Users can insert own orders"
  ON shop_orders FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can read own orders"
  ON shop_orders FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert order items"
  ON shop_order_items FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM shop_orders
      WHERE shop_orders.id = order_id
      AND shop_orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can read own order items"
  ON shop_order_items FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM shop_orders
      WHERE shop_orders.id = order_id
      AND shop_orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Authenticated users can read config"
  ON shop_config FOR SELECT TO authenticated
  USING (true);

-- Insert default config
INSERT INTO shop_config (key, value) VALUES
  ('order_email_to', 'bunicu@example.com'),
  ('order_email_cc1', 'cc1@example.com'),
  ('order_email_cc2', 'cc2@example.com');
```

**Step 2: Run migration in Supabase**

Apply this SQL via Supabase Studio SQL Editor or Supabase CLI.

**Step 3: Commit**

```bash
git add supabase/migrations/001_shop_tables.sql
git commit -m "feat(shop): add Supabase migration for shop tables"
```

---

### Task 2: Create new domain entities for Supabase shop

**Files:**
- Modify: `lib/features/shop/domain/entities/product_category_entity.dart`
- Modify: `lib/features/shop/domain/entities/product_entity.dart`
- Delete: `lib/features/shop/domain/entities/product_tag_entity.dart`

**Step 1: Rewrite ProductCategoryEntity for UUID-based Supabase schema**

Replace the entire file `lib/features/shop/domain/entities/product_category_entity.dart`:

```dart
import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String? parentId;
  final int sortOrder;

  const ProductCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.parentId,
    this.sortOrder = 0,
  });

  factory ProductCategoryEntity.fromJson(Map<String, dynamic> json) {
    return ProductCategoryEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      parentId: json['parent_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, slug, description, imageUrl, parentId, sortOrder];
}
```

**Step 2: Rewrite ProductEntity for Supabase schema**

Replace the entire file `lib/features/shop/domain/entities/product_entity.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'package:app/features/cart/domain/models/cart_item_model.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? salePrice;
  final List<String> images;
  final String? categoryId;
  final int sortOrder;

  bool get onSale => salePrice != null && salePrice! < price;
  double get displayPrice => onSale ? salePrice! : price;
  String? get firstImage => images.isNotEmpty ? images.first : null;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.salePrice,
    this.images = const [],
    this.categoryId,
    this.sortOrder = 0,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      salePrice: json['sale_price'] != null ? (json['sale_price'] as num).toDouble() : null,
      images: json['images'] != null ? List<String>.from(json['images'] as List) : [],
      categoryId: json['category_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  CartItemModel toCartModel({int quantity = 1}) {
    return CartItemModel(
      id: id.hashCode, // CartItemModel uses int id for SharedPreferences compat
      name: name,
      imageUrl: firstImage,
      price: displayPrice.toStringAsFixed(2),
      regularPrice: price.toStringAsFixed(2),
      salePrice: salePrice?.toStringAsFixed(2) ?? '',
      onSale: onSale,
      sku: id, // Use UUID as SKU
      quantity: quantity,
      productType: 'product',
    );
  }

  @override
  List<Object?> get props => [id, name, slug, description, price, salePrice, images, categoryId, sortOrder];
}
```

**Step 3: Delete product_tag_entity.dart**

```bash
rm lib/features/shop/domain/entities/product_tag_entity.dart
```

**Step 4: Commit**

```bash
git add -A lib/features/shop/domain/entities/
git commit -m "feat(shop): rewrite domain entities for Supabase UUID schema"
```

---

### Task 3: Create Supabase data source for shop

**Files:**
- Rewrite: `lib/features/shop/data/datasources/shop_remote_data_source.dart`
- Delete: `lib/features/shop/data/models/shop_category_model.dart`
- Delete: `lib/features/shop/data/models/product_model.dart`
- Delete: `lib/features/shop/data/models/product_tag_model.dart`
- Delete: `lib/features/shop/data/models/product_tag_query_params.dart`
- Delete: `lib/features/shop/data/mock/mock_categories.dart`
- Delete: `lib/features/shop/data/mock/mock_products.dart`

**Step 1: Rewrite shop data source to use Supabase**

Replace `lib/features/shop/data/datasources/shop_remote_data_source.dart`:

```dart
import 'package:app/core/network/supabase_client.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

abstract class ShopRemoteDataSource {
  Future<List<ProductCategoryEntity>> getParentCategories();
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId);
  Future<List<ProductEntity>> getProductsByCategory(String categoryId);
  Future<ProductEntity> getProductById(String productId);
  Future<List<ProductEntity>> searchProducts(String query);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final SupabaseClient _supabaseClient;

  ShopRemoteDataSourceImpl() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  @override
  Future<List<ProductCategoryEntity>> getParentCategories() async {
    final response = await _client
        .from('shop_categories')
        .select()
        .isFilter('parent_id', null)
        .order('sort_order');
    return (response as List)
        .map((json) => ProductCategoryEntity.fromJson(json))
        .toList();
  }

  @override
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId) async {
    final response = await _client
        .from('shop_categories')
        .select()
        .eq('parent_id', parentId)
        .order('sort_order');
    return (response as List)
        .map((json) => ProductCategoryEntity.fromJson(json))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryId) async {
    final response = await _client
        .from('shop_products')
        .select()
        .eq('category_id', categoryId)
        .order('sort_order');
    return (response as List)
        .map((json) => ProductEntity.fromJson(json))
        .toList();
  }

  @override
  Future<ProductEntity> getProductById(String productId) async {
    final response = await _client
        .from('shop_products')
        .select()
        .eq('id', productId)
        .single();
    return ProductEntity.fromJson(response);
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final response = await _client
        .from('shop_products')
        .select()
        .ilike('name', '%$query%')
        .order('sort_order');
    return (response as List)
        .map((json) => ProductEntity.fromJson(json))
        .toList();
  }
}
```

**Step 2: Delete old model files and mock data**

```bash
rm lib/features/shop/data/models/shop_category_model.dart
rm lib/features/shop/data/models/product_model.dart
rm lib/features/shop/data/models/product_tag_model.dart
rm lib/features/shop/data/models/product_tag_query_params.dart
rm lib/features/shop/data/mock/mock_categories.dart
rm lib/features/shop/data/mock/mock_products.dart
```

**Step 3: Commit**

```bash
git add -A lib/features/shop/data/
git commit -m "feat(shop): replace WooCommerce data source with Supabase queries"
```

---

### Task 4: Rewrite shop repository and use cases

**Files:**
- Rewrite: `lib/features/shop/data/repositories/shop_repository_impl.dart`
- Rewrite: `lib/features/shop/domain/repositories/shop_repository.dart`
- Delete: `lib/features/shop/domain/usecases/get_categories_usecase.dart`
- Delete: `lib/features/shop/domain/usecases/get_parent_categories_usecase.dart`
- Delete: `lib/features/shop/domain/usecases/get_product_by_id_usecase.dart`
- Delete: `lib/features/shop/domain/usecases/get_products_by_category_usecase.dart`

**Step 1: Simplify ShopRepository interface**

Replace `lib/features/shop/domain/repositories/shop_repository.dart`:

```dart
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';

abstract class ShopRepository {
  Future<List<ProductCategoryEntity>> getParentCategories();
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId);
  Future<List<ProductEntity>> getProductsByCategory(String categoryId);
  Future<ProductEntity> getProductById(String productId);
  Future<List<ProductEntity>> searchProducts(String query);
}
```

**Step 2: Simplify ShopRepositoryImpl (no more fallback/mock)**

Replace `lib/features/shop/data/repositories/shop_repository_impl.dart`:

```dart
import 'package:app/features/shop/data/datasources/shop_remote_data_source.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductCategoryEntity>> getParentCategories() =>
      remoteDataSource.getParentCategories();

  @override
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId) =>
      remoteDataSource.getSubCategories(parentId);

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryId) =>
      remoteDataSource.getProductsByCategory(categoryId);

  @override
  Future<ProductEntity> getProductById(String productId) =>
      remoteDataSource.getProductById(productId);

  @override
  Future<List<ProductEntity>> searchProducts(String query) =>
      remoteDataSource.searchProducts(query);
}
```

**Step 3: Delete use case files (cubits will call repository directly, matching existing pattern)**

```bash
rm lib/features/shop/domain/usecases/get_categories_usecase.dart
rm lib/features/shop/domain/usecases/get_parent_categories_usecase.dart
rm lib/features/shop/domain/usecases/get_product_by_id_usecase.dart
rm lib/features/shop/domain/usecases/get_products_by_category_usecase.dart
```

**Step 4: Commit**

```bash
git add -A lib/features/shop/domain/ lib/features/shop/data/repositories/
git commit -m "feat(shop): simplify repository and remove WooCommerce use cases"
```

---

### Task 5: Rewrite shop cubits for Supabase

**Files:**
- Rewrite: `lib/features/shop/presentation/cubit/categories/categories_cubit.dart`
- Rewrite: `lib/features/shop/presentation/cubit/categories/categories_state.dart`
- Rewrite: `lib/features/shop/presentation/cubit/products/products_cubit.dart`
- Rewrite: `lib/features/shop/presentation/cubit/products/products_state.dart`
- Rewrite: `lib/features/shop/presentation/cubit/product_detail/product_detail_cubit.dart`
- Rewrite: `lib/features/shop/presentation/cubit/product_detail/product_detail_state.dart`
- Rewrite: `lib/features/shop/presentation/cubit/search_products/search_products_cubit.dart`
- Rewrite: `lib/features/shop/presentation/cubit/search_products/search_products_state.dart`
- Delete: `lib/features/shop/presentation/cubit/search_products/cubit/` (duplicate folder)

**Step 1: Rewrite CategoriesCubit**

Replace `lib/features/shop/presentation/cubit/categories/categories_cubit.dart`:

```dart
import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(const CategoriesState());

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final categories = await sl<ShopRepository>().getParentCategories();
      emit(state.copyWith(categories: categories, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

Replace `lib/features/shop/presentation/cubit/categories/categories_state.dart`:

```dart
part of 'categories_cubit.dart';

class CategoriesState extends Equatable {
  final List<ProductCategoryEntity> categories;
  final bool isLoading;
  final String? error;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<ProductCategoryEntity>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, error];
}
```

**Step 2: Rewrite ProductsCubit**

Replace `lib/features/shop/presentation/cubit/products/products_cubit.dart`:

```dart
import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final String categoryId;

  ProductsCubit({required this.categoryId}) : super(const ProductsState());

  Future<void> loadProducts() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await sl<ShopRepository>().getProductsByCategory(categoryId);
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

Replace `lib/features/shop/presentation/cubit/products/products_state.dart`:

```dart
part of 'products_cubit.dart';

class ProductsState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  ProductsState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, error];
}
```

**Step 3: Rewrite ProductDetailCubit**

Replace `lib/features/shop/presentation/cubit/product_detail/product_detail_cubit.dart`:

```dart
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(const ProductDetailState());

  void setProduct(ProductEntity product) {
    emit(state.copyWith(product: product, isLoading: false));
  }
}
```

Replace `lib/features/shop/presentation/cubit/product_detail/product_detail_state.dart`:

```dart
part of 'product_detail_cubit.dart';

class ProductDetailState extends Equatable {
  final ProductEntity? product;
  final bool isLoading;
  final String? error;

  const ProductDetailState({
    this.product,
    this.isLoading = false,
    this.error,
  });

  ProductDetailState copyWith({
    ProductEntity? product,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [product, isLoading, error];
}
```

**Step 4: Rewrite SearchProductsCubit**

Replace `lib/features/shop/presentation/cubit/search_products/search_products_cubit.dart`:

```dart
import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit() : super(const SearchProductsState());

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      emit(const SearchProductsState());
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await sl<ShopRepository>().searchProducts(query);
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

Replace `lib/features/shop/presentation/cubit/search_products/search_products_state.dart`:

```dart
part of 'search_products_cubit.dart';

class SearchProductsState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;

  const SearchProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  SearchProductsState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? error,
  }) {
    return SearchProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, error];
}
```

**Step 5: Delete duplicate search cubit folder**

```bash
rm -rf lib/features/shop/presentation/cubit/search_products/cubit/
```

**Step 6: Commit**

```bash
git add -A lib/features/shop/presentation/cubit/
git commit -m "feat(shop): rewrite all cubits for Supabase data flow"
```

---

### Task 6: Update shop UI pages for new entities

**Files:**
- Modify: `lib/features/shop/presentation/pages/categories_page.dart`
- Modify: `lib/features/shop/presentation/pages/products_page.dart`
- Modify: `lib/features/shop/presentation/pages/product_detail_page.dart`
- Modify: `lib/features/shop/presentation/pages/search_products_page.dart`
- Modify: `lib/features/shop/presentation/widgets/category_card.dart`
- Modify: `lib/features/shop/presentation/widgets/product_card.dart`
- Delete filter widgets that depend on tags/subcategories: `tags_filter_section.dart`, `category_filter_section.dart`, `product_filters/` folder, `multi_select_*.dart` files, `products_search_bar.dart`

The key changes in pages:
- `CategoriesPage`: use `CategoriesCubit()..loadCategories()` instead of old pattern
- `ProductsPage`: receives `ProductCategoryEntity` with `String id` (was `int`), creates `ProductsCubit(categoryId: category.id)..loadProducts()`
- `ProductDetailPage`: receives `ProductEntity` with new shape, update price display to use `product.displayPrice` and `product.price` (doubles, not strings), images from `product.images` (List<String>), remove stock badge, remove HTML strip (description is plain text from Supabase)
- `CategoryCard`: use `category.imageUrl` instead of `category.image`
- `ProductCard`: use `product.firstImage`, `product.displayPrice`, update for double prices
- `SearchProductsPage`: use real `SearchProductsCubit` with Supabase

Read each file before modifying. Adapt the widgets to the new entity shapes. Remove tag/subcategory filter widgets that are no longer needed.

**Step 1: Update pages and widgets one by one, reading each before modifying**

**Step 2: Delete unused filter widgets**

```bash
rm lib/features/shop/presentation/widgets/tags_filter_section.dart
rm lib/features/shop/presentation/widgets/category_filter_section.dart
rm -rf lib/features/shop/presentation/widgets/product_filters/
rm lib/features/shop/presentation/widgets/multi_select_dropdown.dart
rm lib/features/shop/presentation/widgets/multi_select_dropdown_example.dart
rm lib/features/shop/presentation/widgets/multi_select_2_dropdown.dart
rm lib/features/shop/presentation/widgets/multi_select_2_filter_dropdown.dart
rm lib/features/shop/presentation/widgets/products_search_bar.dart
```

**Step 3: Commit**

```bash
git add -A lib/features/shop/presentation/
git commit -m "feat(shop): update UI pages for Supabase entities, remove WooCommerce filters"
```

---

### Task 7: Create order feature (data + domain)

**Files:**
- Create: `lib/features/orders/domain/entities/order_entity.dart`
- Create: `lib/features/orders/domain/entities/order_item_entity.dart`
- Create: `lib/features/orders/domain/repositories/order_repository.dart`
- Create: `lib/features/orders/data/datasources/order_remote_data_source.dart`
- Create: `lib/features/orders/data/repositories/order_repository_impl.dart`

**Step 1: Create order entities**

`lib/features/orders/domain/entities/order_entity.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String status;
  final String? note;
  final double total;
  final String userName;
  final String userEmail;
  final DateTime createdAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.status,
    this.note,
    required this.total,
    required this.userName,
    required this.userEmail,
    required this.createdAt,
    this.items = const [],
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String? ?? 'pending',
      note: json['note'] as String?,
      total: (json['total'] as num).toDouble(),
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: json['shop_order_items'] != null
          ? (json['shop_order_items'] as List)
              .map((item) => OrderItemEntity.fromJson(item))
              .toList()
          : [],
    );
  }

  @override
  List<Object?> get props => [id, userId, status, note, total, userName, userEmail, createdAt, items];
}
```

`lib/features/orders/domain/entities/order_item_entity.dart`:

```dart
import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;

  double get lineTotal => productPrice * quantity;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) {
    return OrderItemEntity(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productPrice: (json['product_price'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }

  @override
  List<Object> get props => [id, orderId, productId, productName, productPrice, quantity];
}
```

**Step 2: Create order repository interface**

`lib/features/orders/domain/repositories/order_repository.dart`:

```dart
import 'package:app/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> placeOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required double total,
    String? note,
    required List<Map<String, dynamic>> items,
  });
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrderById(String orderId);
}
```

**Step 3: Create order data source**

`lib/features/orders/data/datasources/order_remote_data_source.dart`:

```dart
import 'package:app/core/network/supabase_client.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

class OrderRemoteDataSource {
  final SupabaseClient _supabaseClient;

  OrderRemoteDataSource() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  Future<OrderEntity> placeOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required double total,
    String? note,
    required List<Map<String, dynamic>> items,
  }) async {
    // Insert order
    final orderResponse = await _client
        .from('shop_orders')
        .insert({
          'user_id': userId,
          'user_name': userName,
          'user_email': userEmail,
          'total': total,
          'note': note,
        })
        .select()
        .single();

    final orderId = orderResponse['id'] as String;

    // Insert order items
    final orderItems = items.map((item) => {
      ...item,
      'order_id': orderId,
    }).toList();

    await _client.from('shop_order_items').insert(orderItems);

    // Call edge function to send email
    await _client.functions.invoke(
      'send-order-email',
      body: {'order_id': orderId},
    );

    // Return the created order with items
    return getOrderById(orderId);
  }

  Future<List<OrderEntity>> getOrders() async {
    final response = await _client
        .from('shop_orders')
        .select('*, shop_order_items(*)')
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => OrderEntity.fromJson(json))
        .toList();
  }

  Future<OrderEntity> getOrderById(String orderId) async {
    final response = await _client
        .from('shop_orders')
        .select('*, shop_order_items(*)')
        .eq('id', orderId)
        .single();
    return OrderEntity.fromJson(response);
  }
}
```

**Step 4: Create order repository implementation**

`lib/features/orders/data/repositories/order_repository_impl.dart`:

```dart
import 'package:app/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:app/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource dataSource;

  OrderRepositoryImpl({required this.dataSource});

  @override
  Future<OrderEntity> placeOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required double total,
    String? note,
    required List<Map<String, dynamic>> items,
  }) => dataSource.placeOrder(
    userId: userId,
    userName: userName,
    userEmail: userEmail,
    total: total,
    note: note,
    items: items,
  );

  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();

  @override
  Future<OrderEntity> getOrderById(String orderId) => dataSource.getOrderById(orderId);
}
```

**Step 5: Commit**

```bash
git add lib/features/orders/
git commit -m "feat(orders): add order entities, data source, and repository for Supabase"
```

---

### Task 8: Create order cubit and checkout flow

**Files:**
- Create: `lib/features/orders/presentation/cubit/order_cubit.dart`
- Create: `lib/features/orders/presentation/cubit/order_state.dart`
- Create: `lib/features/orders/presentation/cubit/order_history_cubit.dart`
- Create: `lib/features/orders/presentation/cubit/order_history_state.dart`

**Step 1: Create OrderCubit (for placing orders)**

`lib/features/orders/presentation/cubit/order_cubit.dart`:

```dart
import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/domain/models/cart_model.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:app/features/orders/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  Future<void> placeOrder({
    required CartModel cart,
    String? note,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = Supabase.instance.client.auth.currentUser!;
      final userName = user.userMetadata?['full_name'] as String? ??
          user.userMetadata?['name'] as String? ??
          user.email ?? 'Unknown';
      final userEmail = user.email ?? '';

      final items = cart.items.map((item) => {
        'product_id': item.sku, // sku holds the UUID
        'product_name': item.name,
        'product_price': double.tryParse(item.price) ?? 0.0,
        'quantity': item.quantity,
      }).toList();

      final order = await sl<OrderRepository>().placeOrder(
        userId: user.id,
        userName: userName,
        userEmail: userEmail,
        total: cart.totalPrice,
        note: note,
        items: items,
      );

      emit(state.copyWith(isLoading: false, order: order));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

`lib/features/orders/presentation/cubit/order_state.dart`:

```dart
part of 'order_cubit.dart';

class OrderState extends Equatable {
  final bool isLoading;
  final OrderEntity? order;
  final String? error;

  const OrderState({
    this.isLoading = false,
    this.order,
    this.error,
  });

  OrderState copyWith({
    bool? isLoading,
    OrderEntity? order,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, order, error];
}
```

**Step 2: Create OrderHistoryCubit**

`lib/features/orders/presentation/cubit/order_history_cubit.dart`:

```dart
import 'package:app/core/service_locator.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:app/features/orders/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(const OrderHistoryState());

  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final orders = await sl<OrderRepository>().getOrders();
      emit(state.copyWith(orders: orders, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

`lib/features/orders/presentation/cubit/order_history_state.dart`:

```dart
part of 'order_history_cubit.dart';

class OrderHistoryState extends Equatable {
  final List<OrderEntity> orders;
  final bool isLoading;
  final String? error;

  const OrderHistoryState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrderHistoryState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, error];
}
```

**Step 3: Commit**

```bash
git add lib/features/orders/presentation/
git commit -m "feat(orders): add OrderCubit and OrderHistoryCubit"
```

---

### Task 9: Create order pages (checkout replacement + history)

**Files:**
- Create: `lib/features/orders/presentation/pages/place_order_page.dart`
- Create: `lib/features/orders/presentation/pages/order_success_page.dart`
- Create: `lib/features/orders/presentation/pages/order_history_page.dart`
- Create: `lib/features/orders/presentation/pages/order_detail_page.dart`

**Step 1: Create PlaceOrderPage (replaces CheckoutPage)**

`lib/features/orders/presentation/pages/place_order_page.dart`:

Simple page shown from cart: displays order summary (items, total), optional note TextField, and "Trimite comanda" button. On tap calls `OrderCubit.placeOrder()` then navigates to success page and clears cart.

**Step 2: Create OrderSuccessPage**

`lib/features/orders/presentation/pages/order_success_page.dart`:

Success screen with check icon, "Comanda a fost trimisa!" message, "Vezi comenzile" button (navigates to order history), "Inapoi la magazin" button.

**Step 3: Create OrderHistoryPage**

`lib/features/orders/presentation/pages/order_history_page.dart`:

Uses `OrderHistoryCubit`. Lists orders as cards showing: date, status chip, total, number of items. Tap navigates to detail.

**Step 4: Create OrderDetailPage**

`lib/features/orders/presentation/pages/order_detail_page.dart`:

Shows order info (date, status, note) and list of order items (product name, price, quantity, line total). Total at bottom.

**Step 5: Commit**

```bash
git add lib/features/orders/presentation/pages/
git commit -m "feat(orders): add order pages - place order, success, history, detail"
```

---

### Task 10: Simplify cart (remove stock check, update checkout navigation)

**Files:**
- Modify: `lib/features/cart/presentation/cubit/cart_cubit.dart`
- Modify: `lib/features/cart/presentation/cubit/cart_state.dart`
- Modify: `lib/features/cart/presentation/pages/cart_page.dart`
- Modify: `lib/features/cart/presentation/widgets/cart_summary.dart`
- Modify: `lib/features/cart/presentation/widgets/cart_item_card.dart`
- Modify: `lib/features/cart/domain/repositories/cart_repository.dart`
- Delete: `lib/features/cart/data/datasource/cart_stock_datasource.dart`
- Delete: `lib/features/cart/data/datasource/mock_cart_stock_datasource.dart`
- Delete: `lib/features/cart/data/request/cart_stock_request.dart`
- Delete: `lib/features/cart/domain/models/cart_stock_response_model.dart`

Key changes:
- CartCubit: remove all `verifyStock` calls, remove `checkCurrentStock()`, remove `cartStock` from state
- CartState: remove `cartStock`, `isCheckoutLoading` fields
- CartPage: navigate to `placeOrder` route instead of `checkout`, remove stock error dialogs
- CartSummary: remove stock gate, just navigate directly
- CartRepository: remove `verifyStock` method
- CartItemCard: remove stock info display

**Step 1: Simplify each file, reading before modifying**

**Step 2: Delete stock-related files**

```bash
rm lib/features/cart/data/datasource/cart_stock_datasource.dart
rm lib/features/cart/data/datasource/mock_cart_stock_datasource.dart
rm lib/features/cart/data/request/cart_stock_request.dart
rm lib/features/cart/domain/models/cart_stock_response_model.dart
```

**Step 3: Commit**

```bash
git add -A lib/features/cart/
git commit -m "feat(cart): remove stock check, simplify for Supabase checkout"
```

---

### Task 11: Update routing and service locator

**Files:**
- Modify: `lib/core/navigation/routes_name.dart`
- Modify: `lib/core/navigation/routes.dart`
- Modify: `lib/core/service_locator.dart`

**Step 1: Add new route names**

Add to `routes_name.dart`:

```dart
// Orders
orderHistory(name: 'order_history', path: '/order-history'),
placeOrder(name: 'place_order', path: 'place-order'),
orderSuccess(name: 'order_success', path: 'order-success'),
orderDetail(name: 'order_detail', path: 'order-detail'),
```

**Step 2: Add new routes to routes.dart**

- Replace checkout route under cart with `placeOrder` route pointing to `PlaceOrderPage`
- Add `orderSuccess` as sub-route of `placeOrder`
- Add `orderHistory` as top-level ShellRoute child pointing to `OrderHistoryPage`
- Add `orderDetail` as sub-route of `orderHistory`
- Remove `paymentWebView` route
- Remove old checkout import, add new order page imports

**Step 3: Update service_locator.dart**

- Remove: WooCommerceApiClient registration, ShopRemoteDataSource (old), CartStockDatasource, OrderDataSource (old), OrderRepository (old), CheckoutService, CheckoutCubit, old shop use cases
- Add: new ShopRemoteDataSource (Supabase), OrderRemoteDataSource, OrderRepository (new)
- Simplify CartRepository registration (no stock datasource)

**Step 4: Commit**

```bash
git add lib/core/navigation/ lib/core/service_locator.dart
git commit -m "feat: update routing and DI for Supabase shop and orders"
```

---

### Task 12: Delete old checkout feature and WooCommerce client

**Files:**
- Delete entire: `lib/features/checkout/` directory
- Delete: `lib/core/network/woocommerce_api_client.dart`

**Step 1: Delete files**

```bash
rm -rf lib/features/checkout/
rm lib/core/network/woocommerce_api_client.dart
```

**Step 2: Remove WooCommerce env vars from .env (optional, keep if other features use them)**

**Step 3: Commit**

```bash
git add -A
git commit -m "chore: remove WooCommerce client and old checkout feature"
```

---

### Task 13: Add order history link to profile page

**Files:**
- Modify: `lib/features/profile/presentation/pages/profile_page.dart`
- Or modify the relevant profile section widget

**Step 1: Read profile page and section widgets to find where to add the link**

**Step 2: Add "Comenzile mele" menu item that navigates to `orderHistory` route**

Follow the existing pattern (ProfileMenuItem widget). Place it in the account section alongside other menu items.

**Step 3: Commit**

```bash
git add lib/features/profile/
git commit -m "feat(profile): add order history link to profile page"
```

---

### Task 14: Create Supabase Edge Function for email

**Files:**
- Create: `supabase/functions/send-order-email/index.ts`

**Step 1: Write the edge function**

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
  const { order_id } = await req.json();

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // Get order with items
  const { data: order, error: orderError } = await supabase
    .from("shop_orders")
    .select("*, shop_order_items(*)")
    .eq("id", order_id)
    .single();

  if (orderError) {
    return new Response(JSON.stringify({ error: orderError.message }), {
      status: 400,
    });
  }

  // Get email config
  const { data: config } = await supabase
    .from("shop_config")
    .select("key, value")
    .in_("key", ["order_email_to", "order_email_cc1", "order_email_cc2"]);

  const emailConfig: Record<string, string> = {};
  config?.forEach((row: { key: string; value: string }) => {
    emailConfig[row.key] = row.value;
  });

  const toEmail = emailConfig["order_email_to"];
  const ccEmails = [
    emailConfig["order_email_cc1"],
    emailConfig["order_email_cc2"],
  ].filter(Boolean);

  // Build HTML email
  const itemsHtml = order.shop_order_items
    .map(
      (item: any) =>
        `<tr>
          <td style="padding:8px;border:1px solid #ddd">${item.product_name}</td>
          <td style="padding:8px;border:1px solid #ddd;text-align:center">${item.quantity}</td>
          <td style="padding:8px;border:1px solid #ddd;text-align:right">${item.product_price.toFixed(2)} Lei</td>
          <td style="padding:8px;border:1px solid #ddd;text-align:right">${(item.product_price * item.quantity).toFixed(2)} Lei</td>
        </tr>`
    )
    .join("");

  const html = `
    <h2>Comanda noua de la ${order.user_name}</h2>
    <p><strong>Email:</strong> ${order.user_email}</p>
    <p><strong>Data:</strong> ${new Date(order.created_at).toLocaleString("ro-RO")}</p>
    ${order.note ? `<p><strong>Nota:</strong> ${order.note}</p>` : ""}
    <table style="border-collapse:collapse;width:100%">
      <thead>
        <tr style="background:#f5f5f5">
          <th style="padding:8px;border:1px solid #ddd;text-align:left">Produs</th>
          <th style="padding:8px;border:1px solid #ddd">Cantitate</th>
          <th style="padding:8px;border:1px solid #ddd;text-align:right">Pret</th>
          <th style="padding:8px;border:1px solid #ddd;text-align:right">Subtotal</th>
        </tr>
      </thead>
      <tbody>${itemsHtml}</tbody>
      <tfoot>
        <tr>
          <td colspan="3" style="padding:8px;border:1px solid #ddd;text-align:right"><strong>Total:</strong></td>
          <td style="padding:8px;border:1px solid #ddd;text-align:right"><strong>${order.total.toFixed(2)} Lei</strong></td>
        </tr>
      </tfoot>
    </table>
  `;

  // Send via Resend
  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${RESEND_API_KEY}`,
    },
    body: JSON.stringify({
      from: "Cavalerii Templului <noreply@rl126ct.dev.icefelix.com>",
      to: [toEmail],
      cc: ccEmails,
      subject: `Comanda noua de la ${order.user_name}`,
      html: html,
    }),
  });

  const resendResult = await res.json();

  return new Response(JSON.stringify({ success: true, resend: resendResult }), {
    headers: { "Content-Type": "application/json" },
  });
});
```

**Step 2: Deploy and set secrets**

```bash
# Set Resend API key as secret
supabase secrets set RESEND_API_KEY=re_xxxxx

# Deploy
supabase functions deploy send-order-email
```

**Step 3: Commit**

```bash
git add supabase/functions/
git commit -m "feat: add send-order-email edge function with Resend.io"
```

---

### Task 15: Fix imports and verify compilation

**Step 1: Run `flutter analyze` and fix all import errors**

```bash
flutter analyze
```

Expected: errors from removed imports, changed types (int→String for IDs), missing imports. Fix each one.

**Step 2: Run `flutter build apk --debug` to verify compilation**

```bash
flutter build apk --debug
```

**Step 3: Commit**

```bash
git add -A
git commit -m "fix: resolve all import and type errors after shop migration"
```

---

### Task 16: Seed test data in Supabase

**Step 1: Insert sample categories and products via Supabase Studio or SQL**

```sql
-- Sample categories
INSERT INTO shop_categories (name, slug, description, image_url, sort_order) VALUES
  ('Imbracaminte', 'imbracaminte', 'Articole vestimentare masonice', null, 1),
  ('Carti', 'carti', 'Carti si publicatii', null, 2),
  ('Suveniruri', 'suveniruri', 'Suveniruri si obiecte de colectie', null, 3);

-- Sample products (use the category IDs from above)
-- Insert via Supabase Studio for convenience
```

**Step 2: Insert email config**

Update the `shop_config` table with real email addresses via Supabase Studio.

**Step 3: Test the full flow in the app**

1. Open shop → categories load from Supabase
2. Tap category → products load
3. Tap product → detail page shows correctly
4. Add to cart → cart works
5. Place order → order saved, email sent
6. Profile → order history shows the order
