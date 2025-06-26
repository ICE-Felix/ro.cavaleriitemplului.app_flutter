import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/news_entity.dart';
import '../repositories/news_repository.dart';

class SearchNewsUseCase extends UseCase<List<NewsEntity>, SearchNewsParams> {
  final NewsRepository repository;

  SearchNewsUseCase({required this.repository});

  @override
  Future<List<NewsEntity>> call(SearchNewsParams params) async {
    return await repository.searchNews(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchNewsParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchNewsParams({required this.query, this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [query, page, limit];
}
