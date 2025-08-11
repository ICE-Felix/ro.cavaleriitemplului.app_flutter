import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/news_entity.dart';
import '../repositories/news_repository.dart';

class GetNewsByIdUseCase extends UseCase<NewsEntity, GetNewsByIdParams> {
  final NewsRepository repository;

  GetNewsByIdUseCase({required this.repository});

  @override
  Future<NewsEntity> call(GetNewsByIdParams params) async {
    return await repository.getNewsById(params.id);
  }
}

class GetNewsByIdParams extends Equatable {
  final String id;

  const GetNewsByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
