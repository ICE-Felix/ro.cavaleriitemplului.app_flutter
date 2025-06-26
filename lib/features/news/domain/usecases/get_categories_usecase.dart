import '../../../../core/usecases/usecase.dart';
import '../repositories/news_repository.dart';

class GetCategoriesUseCase extends NoParamsUseCase<List<String>> {
  final NewsRepository repository;

  GetCategoriesUseCase({required this.repository});

  @override
  Future<List<String>> call() async {
    return await repository.getCategories();
  }
}
