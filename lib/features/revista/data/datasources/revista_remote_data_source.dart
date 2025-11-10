import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/revista_model.dart';
import 'google_drive_service.dart';

abstract class RevistaRemoteDataSource {
  Future<List<RevistaModel>> getRevistas({int page = 1, int limit = 10});
  Future<RevistaModel> getRevistaById(String id);
  Future<String> getAuthenticatedPdfUrl(String fileId);
  Future<String> downloadPdfFile(String fileId, String fileName);
}

class RevistaRemoteDataSourceImpl implements RevistaRemoteDataSource {
  final SupabaseAuthClient _authClient;
  final GoogleDriveService _googleDriveService;

  RevistaRemoteDataSourceImpl()
      : _authClient = SupabaseAuthClient(),
        _googleDriveService = GoogleDriveService();

  @override
  Future<List<RevistaModel>> getRevistas({int page = 1, int limit = 10}) async {
    try {
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      // Make API call to fetch revistas
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/revistas',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch revistas: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message: 'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> revistasData = responseData['data'] ?? [];

      // Convert to RevistaModel objects
      final revistas = revistasData
          .map((revistaJson) => RevistaModel.fromJson(revistaJson))
          .toList();

      return revistas;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RevistaModel> getRevistaById(String id) async {
    try {
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Make API call to fetch specific revista by ID
      final response = await http.get(
        Uri.parse('${dotenv.get('SUPABASE_URL')}/functions/v1/revistas/$id'),
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          throw ServerException(message: 'Revista not found');
        }
        throw ServerException(
          message: 'Failed to fetch revista: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message: 'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      // Convert to RevistaModel object
      final revistaData = responseData['data'];
      final revista = RevistaModel.fromJson(revistaData);

      return revista;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> getAuthenticatedPdfUrl(String fileId) async {
    try {
      return await _googleDriveService.getAuthenticatedUrl(fileId);
    } catch (e) {
      throw ServerException(
        message: 'Failed to get PDF URL: ${e.toString()}',
      );
    }
  }

  @override
  Future<String> downloadPdfFile(String fileId, String fileName) async {
    try {
      return await _googleDriveService.downloadPdfFile(fileId, fileName);
    } catch (e) {
      throw ServerException(
        message: 'Failed to download PDF: ${e.toString()}',
      );
    }
  }
}
