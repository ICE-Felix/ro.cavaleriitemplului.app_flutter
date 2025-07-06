import '../../../../core/usecases/usecase.dart';
import '../repositories/bookmark_repository.dart';

class ToggleBookmarkUseCase implements UseCase<bool, ToggleBookmarkParams> {
  final BookmarkRepository repository;

  ToggleBookmarkUseCase(this.repository);

  @override
  Future<bool> call(ToggleBookmarkParams params) async {
    final isCurrentlyBookmarked = await repository.isBookmarked(params.newsId);

    if (isCurrentlyBookmarked) {
      await repository.removeBookmark(params.newsId);
      return false; // Now unbookmarked
    } else {
      await repository.addBookmark(
        newsId: params.newsId,
        title: params.title,
        summary: params.summary,
        imageUrl: params.imageUrl,
        author: params.author,
        category: params.category,
        source: params.source,
      );
      return true; // Now bookmarked
    }
  }
}

class ToggleBookmarkParams {
  final String newsId;
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final String category;
  final String source;

  ToggleBookmarkParams({
    required this.newsId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.category,
    required this.source,
  });
}
