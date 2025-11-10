import '../../domain/entities/revista_entity.dart';
import '../../domain/repositories/revista_repository.dart';
import '../datasources/revista_remote_data_source.dart';

class RevistaRepositoryImpl implements RevistaRepository {
  final RevistaRemoteDataSource remoteDataSource;

  RevistaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RevistaEntity>> getRevistas({int page = 1, int limit = 10}) async {
    return await remoteDataSource.getRevistas(page: page, limit: limit);
  }

  @override
  Future<RevistaEntity> getRevistaById(String id) async {
    return await remoteDataSource.getRevistaById(id);
  }

  @override
  Future<String> getAuthenticatedPdfUrl(String fileId) async {
    return await remoteDataSource.getAuthenticatedPdfUrl(fileId);
  }

  @override
  Future<String> downloadPdfFile(String fileId, String fileName) async {
    return await remoteDataSource.downloadPdfFile(fileId, fileName);
  }
}
