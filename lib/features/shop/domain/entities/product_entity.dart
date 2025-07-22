import 'package:equatable/equatable.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String permalink;
  final String dateCreated;
  final String dateModified;
  final String type;
  final String status;
  final bool featured;
  final String catalogVisibility;
  final String description;
  final String shortDescription;
  final String sku;
  final String price;
  final String regularPrice;
  final String salePrice;
  final bool onSale;
  final bool purchasable;
  final int totalSales;
  final bool virtual;
  final bool downloadable;
  final bool manageStock;
  final int? stockQuantity;
  final String stockStatus;
  final bool hasOptions;
  final List<ProductImageEntity> images;
  final List<ProductCategoryEntity> categories;
  final List<ProductBrandEntity> brands;
  final String priceHtml;
  final List<int> relatedIds;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.dateCreated,
    required this.dateModified,
    required this.type,
    required this.status,
    required this.featured,
    required this.catalogVisibility,
    required this.description,
    required this.shortDescription,
    required this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    required this.purchasable,
    required this.totalSales,
    required this.virtual,
    required this.downloadable,
    required this.manageStock,
    this.stockQuantity,
    required this.stockStatus,
    required this.hasOptions,
    required this.images,
    required this.categories,
    required this.brands,
    required this.priceHtml,
    required this.relatedIds,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    permalink,
    dateCreated,
    dateModified,
    type,
    status,
    featured,
    catalogVisibility,
    description,
    shortDescription,
    sku,
    price,
    regularPrice,
    salePrice,
    onSale,
    purchasable,
    totalSales,
    virtual,
    downloadable,
    manageStock,
    stockQuantity,
    stockStatus,
    hasOptions,
    images,
    categories,
    brands,
    priceHtml,
    relatedIds,
  ];
}

class ProductImageEntity extends Equatable {
  final int id;
  final String dateCreated;
  final String src;
  final String name;
  final String alt;

  const ProductImageEntity({
    required this.id,
    required this.dateCreated,
    required this.src,
    required this.name,
    required this.alt,
  });

  @override
  List<Object> get props => [id, dateCreated, src, name, alt];
}

class ProductBrandEntity extends Equatable {
  final int id;
  final String name;
  final String slug;

  const ProductBrandEntity({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object> get props => [id, name, slug];
}
 