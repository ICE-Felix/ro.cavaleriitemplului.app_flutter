import '../../domain/entities/revista_entity.dart';
import '../../domain/repositories/revista_repository.dart';
import '../mock/mock_revistas.dart';

/// Mock implementation of RevistaRepository for development and testing
class RevistaRepositoryMock implements RevistaRepository {
  @override
  Future<List<RevistaEntity>> getRevistas({
    int page = 1,
    int limit = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return MockRevistas.getPaginatedRevistas(
      page: page,
      pageSize: limit,
    );
  }

  @override
  Future<RevistaEntity> getRevistaById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final revista = MockRevistas.getRevistaById(id);
    if (revista == null) {
      throw Exception('Revista not found');
    }
    return revista;
  }

  @override
  Future<String> getAuthenticatedPdfUrl(String fileId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return a mock PDF URL (in production, this would be a Google Drive authenticated URL)
    return 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
  }

  @override
  Future<String> downloadPdfFile(String fileId, String fileName) async {
    // Simulate download delay
    await Future.delayed(const Duration(seconds: 2));

    // Return a mock local file path
    return '/mock/path/to/$fileName.pdf';
  }

  @override
  Future<List<RevistaEntity>> searchRevistas(String query, {int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final all = MockRevistas.getPaginatedRevistas(page: 1, pageSize: 100);
    final q = query.toLowerCase();
    return all.where((r) => r.title.toLowerCase().contains(q) || r.description.toLowerCase().contains(q)).take(limit).toList();
  }
}
