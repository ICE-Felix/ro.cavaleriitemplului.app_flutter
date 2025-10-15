import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/dio_client.dart';
import 'package:app/features/locations/data/models/location_category_model.dart';
import 'package:app/features/locations/data/models/location_model.dart';

class AttributeFilterOption {
  final String value;
  final String uuid;

  const AttributeFilterOption({required this.value, required this.uuid});

  factory AttributeFilterOption.fromJson(Map<String, dynamic> json) {
    return AttributeFilterOption(
      value: json['value'] as String,
      uuid: json['uuid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'uuid': uuid};
  }
}

abstract class LocationsRemoteDataSource {
  Future<String> getLocationsBannerUrl();
  Future<List<LocationCategoryModel>> getAllLocationCategories();
  Future<List<LocationCategoryModel>> getAllParentCategories();
  Future<List<LocationCategoryModel>> getAllSubCategories(String parentId);
  Future<List<LocationModel>> getAllLoactionsForCategory(String? categoryId);
  Future<LocationModel> getLocationById(String locationId);
  Future<Map<String, List<AttributeFilterOption>>> getVenueAttributeFilters();
  Future<List<LocationModel>> getAllLoactionsForCategoryWithFilters(
    String categoryId, {
    List<String>? attributeFilters,
  });
}

class LocationsRemoteDataSourceImpl implements LocationsRemoteDataSource {
  final DioClient dio;
  LocationsRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> getLocationsBannerUrl() async {
    try {
      return 'https://www.mommyhai.com/wp-content/uploads/2025/08/WhatsApp-Image-2025-08-12-at-09.41.54.webp';
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LocationCategoryModel>> getAllLocationCategories() async {
    try {
      final response = await dio.get('/venue_categories');
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data
          .map((e) => LocationCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LocationModel>> getAllLoactionsForCategory(
    String? categoryId,
  ) async {
    try {
      final response = await dio.get(
        '/venues',
        queryParameters: {if (categoryId != null) 'category_id': categoryId},
      );
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LocationCategoryModel>> getAllParentCategories() async {
    try {
      final response = await dio.get(
        '/venue_categories',
        queryParameters: {'parents_only': 'true'},
      );
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data
          .map((e) => LocationCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LocationCategoryModel>> getAllSubCategories(
    String parentId,
  ) async {
    try {
      final response = await dio.get(
        '/venue_categories',
        queryParameters: {'parent_id': parentId},
      );
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data
          .map((e) => LocationCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LocationModel> getLocationById(String locationId) async {
    try {
      final response = await dio.get('/venues/$locationId');
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      final Map<String, dynamic> data =
          response['data'] as Map<String, dynamic>;
      return LocationModel.fromJson(data);
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, List<AttributeFilterOption>>>
  getVenueAttributeFilters() async {
    try {
      final response = await dio.get('/venue_attributes_filters');
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      final Map<String, dynamic> data =
          response['data'] as Map<String, dynamic>;
      final Map<String, List<AttributeFilterOption>> result = {};

      data.forEach((key, value) {
        if (value is List) {
          result[key] =
              value
                  .map(
                    (e) => AttributeFilterOption.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList();
        }
      });

      return result;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LocationModel>> getAllLoactionsForCategoryWithFilters(
    String categoryId, {
    List<String>? attributeFilters,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {'category_id': categoryId};
      if (attributeFilters != null && attributeFilters.isNotEmpty) {
        queryParameters['attribute_filters'] = attributeFilters;
      }

      final response = await dio.get(
        '/venues',
        queryParameters: queryParameters,
      );
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
