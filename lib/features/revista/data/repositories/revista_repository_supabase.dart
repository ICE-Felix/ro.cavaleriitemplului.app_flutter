import 'dart:io';

import 'package:app/core/network/supabase_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

import '../../domain/entities/revista_entity.dart';
import '../../domain/repositories/revista_repository.dart';
import '../models/revista_model.dart';

class RevistaRepositorySupabase implements RevistaRepository {
  supabase_flutter.SupabaseClient get _client => SupabaseClient().client;

  @override
  Future<List<RevistaEntity>> getRevistas({int page = 1, int limit = 10}) async {
    final from = (page - 1) * limit;
    final to = from + limit - 1;

    final data = await _client
        .from('revistas')
        .select()
        .eq('is_active', true)
        .order('published_at', ascending: false)
        .range(from, to);

    return (data as List)
        .map((json) => RevistaModel.fromJson(json))
        .toList();
  }

  @override
  Future<RevistaEntity> getRevistaById(String id) async {
    final data = await _client
        .from('revistas')
        .select()
        .eq('id', id)
        .single();

    return RevistaModel.fromJson(data);
  }

  @override
  Future<String> getAuthenticatedPdfUrl(String storagePath) async {
    // Create a signed URL valid for 1 hour (requires authenticated user)
    final signedUrl = await _client.storage
        .from('revistas')
        .createSignedUrl(storagePath, 3600);
    return signedUrl;
  }

  @override
  Future<String> downloadPdfFile(String storagePath, String fileName) async {
    // Download the file bytes from storage (authenticated)
    final bytes = await _client.storage
        .from('revistas')
        .download(storagePath);

    // Save to local app directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Future<List<RevistaEntity>> searchRevistas(String query, {int limit = 20}) async {
    final data = await _client
        .from('revistas')
        .select()
        .eq('is_active', true)
        .or('title.ilike.%$query%,description.ilike.%$query%,issue_number.ilike.%$query%')
        .order('published_at', ascending: false)
        .limit(limit);

    return (data as List)
        .map((json) => RevistaModel.fromJson(json))
        .toList();
  }
}
