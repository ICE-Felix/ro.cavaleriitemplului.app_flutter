import '../../../../core/usecases/usecase.dart';
import '../repositories/bookmark_repository.dart';

class CheckBookmarkUseCase implements UseCase<bool, String> {
  final BookmarkRepository repository;

  CheckBookmarkUseCase(this.repository);

  @override
  Future<bool> call(String newsId) async {
    return await repository.isBookmarked(newsId);
  }
}
