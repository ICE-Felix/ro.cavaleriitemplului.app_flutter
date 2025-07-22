import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.permalink,
    required super.dateCreated,
    required super.dateModified,
    required super.type,
    required super.status,
    required super.featured,
    required super.catalogVisibility,
    required super.description,
    required super.shortDescription,
    required super.sku,
    required super.price,
    required super.regularPrice,
    required super.salePrice,
    required super.onSale,
    required super.purchasable,
    required super.totalSales,
    required super.virtual,
    required super.downloadable,
    required super.manageStock,
    super.stockQuantity,
    required super.stockStatus,
    required super.hasOptions,
    required super.images,
    required super.categories,
    required super.brands,
    required super.priceHtml,
    required super.relatedIds,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      permalink: json['permalink'] as String,
      dateCreated: json['date_created'] as String,
      dateModified: json['date_modified'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      featured: json['featured'] as bool,
      catalogVisibility: json['catalog_visibility'] as String,
      description: json['description'] as String,
      shortDescription: json['short_description'] as String,
      sku: json['sku'] as String,
      price: json['price'] as String,
      regularPrice: json['regular_price'] as String,
      salePrice: json['sale_price'] as String,
      onSale: json['on_sale'] as bool,
      purchasable: json['purchasable'] as bool,
      totalSales: json['total_sales'] as int,
      virtual: json['virtual'] as bool,
      downloadable: json['downloadable'] as bool,
      manageStock: json['manage_stock'] as bool,
      stockQuantity: json['stock_quantity'] as int?,
      stockStatus: json['stock_status'] as String,
      hasOptions: json['has_options'] as bool,
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (image) =>
                    ProductImageModel.fromJson(image as Map<String, dynamic>),
              )
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (category) => ProductCategoryModel.fromJson(
                  category as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      brands:
          (json['brands'] as List<dynamic>?)
              ?.map(
                (brand) =>
                    ProductBrandModel.fromJson(brand as Map<String, dynamic>),
              )
              .toList() ??
          [],
      priceHtml: json['price_html'] as String,
      relatedIds:
          (json['related_ids'] as List<dynamic>?)
              ?.map((id) => id as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'permalink': permalink,
      'date_created': dateCreated,
      'date_modified': dateModified,
      'type': type,
      'status': status,
      'featured': featured,
      'catalog_visibility': catalogVisibility,
      'description': description,
      'short_description': shortDescription,
      'sku': sku,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'purchasable': purchasable,
      'total_sales': totalSales,
      'virtual': virtual,
      'downloadable': downloadable,
      'manage_stock': manageStock,
      'stock_quantity': stockQuantity,
      'stock_status': stockStatus,
      'has_options': hasOptions,
      'images':
          images.map((image) => (image as ProductImageModel).toJson()).toList(),
      'categories':
          categories
              .map((category) => (category as ProductCategoryModel).toJson())
              .toList(),
      'brands':
          brands.map((brand) => (brand as ProductBrandModel).toJson()).toList(),
      'price_html': priceHtml,
      'related_ids': relatedIds,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      slug: slug,
      permalink: permalink,
      dateCreated: dateCreated,
      dateModified: dateModified,
      type: type,
      status: status,
      featured: featured,
      catalogVisibility: catalogVisibility,
      description: description,
      shortDescription: shortDescription,
      sku: sku,
      price: price,
      regularPrice: regularPrice,
      salePrice: salePrice,
      onSale: onSale,
      purchasable: purchasable,
      totalSales: totalSales,
      virtual: virtual,
      downloadable: downloadable,
      manageStock: manageStock,
      stockQuantity: stockQuantity,
      stockStatus: stockStatus,
      hasOptions: hasOptions,
      images: images,
      categories: categories,
      brands: brands,
      priceHtml: priceHtml,
      relatedIds: relatedIds,
    );
  }
}

class ProductCategoryModel extends ProductCategoryEntity {
  const ProductCategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.parent = 0,
    super.description = '',
    super.display = 'default',
    super.image,
    super.menuOrder = 0,
    super.count = 0,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}

class ProductImageModel extends ProductImageEntity {
  const ProductImageModel({
    required super.id,
    required super.dateCreated,
    required super.src,
    required super.name,
    required super.alt,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] as int,
      dateCreated: json['date_created'] as String,
      src: json['src'] as String,
      name: json['name'] as String,
      alt: json['alt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_created': dateCreated,
      'src': src,
      'name': name,
      'alt': alt,
    };
  }
}

class ProductBrandModel extends ProductBrandEntity {
  const ProductBrandModel({
    required super.id,
    required super.name,
    required super.slug,
  });

  factory ProductBrandModel.fromJson(Map<String, dynamic> json) {
    return ProductBrandModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}
