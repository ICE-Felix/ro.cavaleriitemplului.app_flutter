import 'package:app/core/error/exceptions.dart';
import '../../data/datasources/members_remote_data_source.dart';
import '../../data/datasources/members_local_data_source.dart';
import '../../data/models/member_model.dart';

abstract class MembersRepository {
  Future<List<MemberModel>> getMembers();
  Future<List<MemberModel>> getImportantMembers();
  Future<List<MemberModel>> getFavoriteMembers();
  Future<MemberModel> getMemberById(String id);
  Future<void> toggleFavorite(String memberId);
  Future<bool> isFavorite(String memberId);
}

class MembersRepositoryImpl implements MembersRepository {
  final MembersRemoteDataSource remoteDataSource;
  final MembersLocalDataSource localDataSource;

  MembersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<MemberModel>> getMembers() async {
    try {
      return await remoteDataSource.getMembers();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<MemberModel>> getImportantMembers() async {
    try {
      return await remoteDataSource.getImportantMembers();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<MemberModel> getMemberById(String id) async {
    try {
      return await remoteDataSource.getMemberById(id);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<MemberModel>> getFavoriteMembers() async {
    try {
      final favoriteIds = await localDataSource.getFavoriteMemberIds();
      final allMembers = await remoteDataSource.getMembers();
      return allMembers
          .where((member) => favoriteIds.contains(member.id))
          .toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String memberId) async {
    try {
      await localDataSource.toggleFavorite(memberId);
    } catch (e) {
      throw ServerException(message: 'Failed to toggle favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(String memberId) async {
    try {
      return await localDataSource.isFavorite(memberId);
    } catch (e) {
      return false;
    }
  }
}
