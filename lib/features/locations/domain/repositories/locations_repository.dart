import 'package:app/core/error/exceptions.dart';
import 'package:app/features/locations/data/datasources/locations_remote_data_source.dart';
import 'package:app/features/locations/data/models/location_category_model.dart';
import 'package:app/features/locations/data/models/location_model.dart';

abstract class LocationsRepository {
  Future<List<LocationModel>> getAllLocations();
  Future<String> getLocationsBannerUrl();
  Future<List<LocationCategoryModel>> getAllLocationCategories();
  Future<List<LocationCategoryModel>> getAllParentCategories();
  Future<List<LocationCategoryModel>> getAllSubCategories(String parentId);
  Future<List<LocationModel>> getAllLoactionsForCategory(String categoryId);
  Future<LocationModel> getLocationById(String locationId);
}

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsRemoteDataSource remoteDataSource;

  LocationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LocationModel>> getAllLocations() async {
    try {
      return [];
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<String> getLocationsBannerUrl() async {
    try {
      return await remoteDataSource.getLocationsBannerUrl();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<LocationCategoryModel>> getAllLocationCategories() async {
    try {
      return await remoteDataSource.getAllLocationCategories();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<LocationModel>> getAllLoactionsForCategory(
    String categoryId,
  ) async {
    try {
      return await remoteDataSource.getAllLoactionsForCategory(categoryId);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<LocationCategoryModel>> getAllParentCategories() async {
    try {
      return await remoteDataSource.getAllParentCategories();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<LocationCategoryModel>> getAllSubCategories(
    String parentId,
  ) async {
    try {
      return await remoteDataSource.getAllSubCategories(parentId);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<LocationModel> getLocationById(String locationId) async {
    try {
      return await remoteDataSource.getLocationById(locationId);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }
}
