import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;
import '../models/support_request_model.dart';

abstract class SupportRemoteDataSource {
  Future<void> submitSupportRequest(SupportRequestModel request);
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SupportRemoteDataSourceImpl() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  @override
  Future<void> submitSupportRequest(SupportRequestModel request) async {
    try {
      final response = await _client.functions.invoke(
        'send-support-email',
        body: {
          'name': request.name,
          'email': request.email,
          'subject': request.subject,
          'message': request.message,
          'category': request.category.name,
        },
      );

      if (response.status != 200) {
        throw ServerException(message: 'Eroare la trimiterea mesajului');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Eroare la trimiterea mesajului: $e');
    }
  }
}
