import 'dart:convert';
import 'package:app/features/cart/domain/models/cart_item_model.dart';

class VenueProductModel {
  final String id;
  final String venueId;
  final int wooProductId;
  final int maxCapacity;
  final String priceType;
  final String? galleryId;
  final String? featuredImagePath;
  final String? adHocDates;
  final List<String> venueProductCategories;
  final String? imageUrl;
  final List<VenueProductImage> images;
  final String venueName;
  final List<String> venueProductCategoriesName;
  final String wooName;
  final String wooDescription;
  final String wooShortDescription;
  final String wooPrice;
  final String wooRegularPrice;
  final String wooSalePrice;
  final String wooSku;
  final String wooStatus;
  final String wooStockStatus;
  final int wooStockQuantity;
  final bool wooManageStock;
  final bool wooFeatured;
  final String? wooDateOnSaleFrom;
  final String? wooDateOnSaleTo;
  final List<String> wooTags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  bool get isAvailable => wooStockStatus == 'instock';

  const VenueProductModel({
    required this.id,
    required this.venueId,
    required this.wooProductId,
    required this.maxCapacity,
    required this.priceType,
    this.galleryId,
    this.featuredImagePath,
    this.adHocDates,
    required this.venueProductCategories,
    this.imageUrl,
    required this.images,
    required this.venueName,
    required this.venueProductCategoriesName,
    required this.wooName,
    required this.wooDescription,
    required this.wooShortDescription,
    required this.wooPrice,
    required this.wooRegularPrice,
    required this.wooSalePrice,
    required this.wooSku,
    required this.wooStatus,
    required this.wooStockStatus,
    required this.wooStockQuantity,
    required this.wooManageStock,
    required this.wooFeatured,
    this.wooDateOnSaleFrom,
    this.wooDateOnSaleTo,
    required this.wooTags,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory VenueProductModel.fromJson(Map<String, dynamic> json) {
    return VenueProductModel(
      id: json['id'] as String,
      venueId: json['venue_id'] as String,
      wooProductId: json['woo_product_id'] as int,
      maxCapacity: json['max_capacity'] as int,
      priceType: json['price_type'] as String,
      galleryId: json['gallery_id'] as String?,
      featuredImagePath: json['featured_image_path'] as String?,
      adHocDates: json['ad_hoc_dates'] as String?,
      venueProductCategories:
          (json['venue_product_categories'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      imageUrl: json['image_url'] as String?,
      images:
          (json['images'] as List<dynamic>? ?? [])
              .map((e) => VenueProductImage.fromJson(e as Map<String, dynamic>))
              .toList(),
      venueName: json['venue_name'] as String,
      venueProductCategoriesName:
          (json['venue_product_categories_name'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      wooName: json['woo_name'] as String,
      wooDescription: json['woo_description'] as String,
      wooShortDescription: json['woo_short_description'] as String,
      wooPrice: json['woo_price'] as String,
      wooRegularPrice: json['woo_regular_price'] as String,
      wooSalePrice: json['woo_sale_price'] as String,
      wooSku: json['woo_sku'] as String,
      wooStatus: json['woo_status'] as String,
      wooStockStatus: json['woo_stock_status'] as String,
      wooStockQuantity: json['woo_stock_quantity'] as int,
      wooManageStock: json['woo_manage_stock'] as bool,
      wooFeatured: json['woo_featured'] as bool,
      wooDateOnSaleFrom: json['woo_date_on_sale_from'] as String?,
      wooDateOnSaleTo: json['woo_date_on_sale_to'] as String?,
      wooTags:
          (json['woo_tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venue_id': venueId,
      'woo_product_id': wooProductId,
      'max_capacity': maxCapacity,
      'price_type': priceType,
      'gallery_id': galleryId,
      'featured_image_path': featuredImagePath,
      'ad_hoc_dates': adHocDates,
      'venue_product_categories': venueProductCategories,
      'image_url': imageUrl,
      'images': images.map((e) => e.toJson()).toList(),
      'venue_name': venueName,
      'venue_product_categories_name': venueProductCategoriesName,
      'woo_name': wooName,
      'woo_description': wooDescription,
      'woo_short_description': wooShortDescription,
      'woo_price': wooPrice,
      'woo_regular_price': wooRegularPrice,
      'woo_sale_price': wooSalePrice,
      'woo_sku': wooSku,
      'woo_status': wooStatus,
      'woo_stock_status': wooStockStatus,
      'woo_stock_quantity': wooStockQuantity,
      'woo_manage_stock': wooManageStock,
      'woo_featured': wooFeatured,
      'woo_date_on_sale_from': wooDateOnSaleFrom,
      'woo_date_on_sale_to': wooDateOnSaleTo,
      'woo_tags': wooTags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Get the display price (sale price if available, otherwise regular price)
  String get displayPrice {
    if (wooSalePrice.isNotEmpty && wooSalePrice != '0') {
      return wooSalePrice;
    }
    return wooPrice;
  }

  /// Check if the product is on sale
  bool get isOnSale {
    return wooSalePrice.isNotEmpty &&
        wooSalePrice != '0' &&
        wooSalePrice != wooPrice;
  }

  /// Get the main image URL (featured image or first image from gallery)
  String? get mainImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl;
    }
    if (images.isNotEmpty) {
      return images.first.url;
    }
    return null;
  }

  /// Parse ad hoc dates from JSON string
  List<AdHocDate>? get parsedAdHocDates {
    if (adHocDates == null || adHocDates!.isEmpty) return null;
    try {
      final List<dynamic> datesJson = json.decode(adHocDates!);
      return datesJson
          .map((e) => AdHocDate.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Convert VenueProductModel to CartItemModel
  CartItemModel toCartModel({int quantity = 1}) {
    return CartItemModel(
      id: wooProductId,
      name: wooName,
      imageUrl: mainImageUrl,
      price: displayPrice,
      regularPrice: wooRegularPrice,
      salePrice: wooSalePrice,
      onSale: isOnSale,
      sku: wooSku.isNotEmpty ? wooSku : id,
      quantity: quantity,
      productType: 'venue_product',
    );
  }
}

class VenueProductImage {
  final String id;
  final String fileName;
  final String url;

  const VenueProductImage({
    required this.id,
    required this.fileName,
    required this.url,
  });

  factory VenueProductImage.fromJson(Map<String, dynamic> json) {
    return VenueProductImage(
      id: json['id'] as String,
      fileName: json['file_name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'file_name': fileName, 'url': url};
  }
}

class AdHocDate {
  final String date;
  final List<TimeWindow> windows;

  const AdHocDate({required this.date, required this.windows});

  factory AdHocDate.fromJson(Map<String, dynamic> json) {
    return AdHocDate(
      date: json['date'] as String,
      windows:
          (json['windows'] as List<dynamic>)
              .map((e) => TimeWindow.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'windows': windows.map((e) => e.toJson()).toList()};
  }
}

class TimeWindow {
  final String startTime;
  final String endTime;

  const TimeWindow({required this.startTime, required this.endTime});

  factory TimeWindow.fromJson(Map<String, dynamic> json) {
    return TimeWindow(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'start_time': startTime, 'end_time': endTime};
  }
}
