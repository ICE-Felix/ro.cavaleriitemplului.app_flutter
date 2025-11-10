import '../entities/revista_entity.dart';

abstract class RevistaRepository {
  /// Get all revistas with pagination
  Future<List<RevistaEntity>> getRevistas({int page = 1, int limit = 10});

  /// Get a single revista by ID
  Future<RevistaEntity> getRevistaById(String id);

  /// Get authenticated PDF download URL from Google Drive
  Future<String> getAuthenticatedPdfUrl(String fileId);

  /// Download PDF file from Google Drive for offline viewing
  Future<String> downloadPdfFile(String fileId, String fileName);
}
