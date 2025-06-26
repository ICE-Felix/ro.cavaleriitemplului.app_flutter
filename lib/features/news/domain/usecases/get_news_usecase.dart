import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/news_entity.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase extends UseCase<List<NewsEntity>, GetNewsParams> {
  final NewsRepository repository;

  GetNewsUseCase({required this.repository});

  @override
  Future<List<NewsEntity>> call(GetNewsParams params) async {
    if (params.category != null) {
      return await repository.getNewsByCategory(
        params.category!,
        page: params.page,
        limit: params.limit,
      );
    }
    return await repository.getNews(page: params.page, limit: params.limit);
  }
}

class GetNewsParams extends Equatable {
  final int page;
  final int limit;
  final String? category;

  const GetNewsParams({this.page = 1, this.limit = 20, this.category});

  @override
  List<Object?> get props => [page, limit, category];
}
