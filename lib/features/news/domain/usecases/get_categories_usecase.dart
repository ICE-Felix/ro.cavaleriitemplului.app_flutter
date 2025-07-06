import '../../../../core/usecases/usecase.dart';
import '../repositories/news_repository.dart';
import '../../data/models/category_model.dart';

class GetCategoriesUseCase extends NoParamsUseCase<List<CategoryModel>> {
  final NewsRepository repository;

  GetCategoriesUseCase({required this.repository});

  @override
  Future<List<CategoryModel>> call() async {
    return await repository.getCategories();
  }
}
