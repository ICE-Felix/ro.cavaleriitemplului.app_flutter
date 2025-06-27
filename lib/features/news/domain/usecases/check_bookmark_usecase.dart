import '../../../../core/usecases/usecase.dart';
import '../repositories/bookmark_repository.dart';

class CheckBookmarkUseCase implements UseCase<bool, int> {
  final BookmarkRepository repository;

  CheckBookmarkUseCase(this.repository);

  @override
  Future<bool> call(int newsId) async {
    return await repository.isBookmarked(newsId);
  }
}
