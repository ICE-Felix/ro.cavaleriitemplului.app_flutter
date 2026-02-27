import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/member_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

abstract class MembersRemoteDataSource {
  Future<List<MemberModel>> getMembers();
  Future<List<MemberModel>> getImportantMembers();
  Future<MemberModel> getMemberById(String id);
  Future<List<MemberModel>> searchMembers(String query);
  Future<List<MemberModel>> getTodayBirthdays();
}

class MembersRemoteDataSourceImpl implements MembersRemoteDataSource {
  final SupabaseClient _supabaseClient;

  MembersRemoteDataSourceImpl() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  @override
  Future<List<MemberModel>> getMembers() async {
    try {
      final data = await _client
          .from('members')
          .select()
          .order('order_display');

      return (data as List)
          .map((json) => MemberModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberModel>> getImportantMembers() async {
    try {
      final data = await _client
          .from('members')
          .select()
          .eq('is_important', true)
          .order('order_display');

      return (data as List)
          .map((json) => MemberModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MemberModel> getMemberById(String id) async {
    try {
      final data = await _client
          .from('members')
          .select()
          .eq('id', id)
          .single();

      return MemberModel.fromJson(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberModel>> searchMembers(String query) async {
    try {
      final data = await _client
          .from('members')
          .select()
          .or('name.ilike.%$query%,title.ilike.%$query%,position.ilike.%$query%')
          .order('order_display');

      return (data as List)
          .map((json) => MemberModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberModel>> getTodayBirthdays() async {
    try {
      final data = await _client.rpc('get_today_birthdays');

      return (data as List)
          .map((json) => MemberModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
