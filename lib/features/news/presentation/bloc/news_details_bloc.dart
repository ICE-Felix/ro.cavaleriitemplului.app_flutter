import 'package:app/features/news/domain/entities/news_entity.dart';
import 'package:app/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/service_locator.dart';

part 'news_details_event.dart';
part 'news_details_state.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  NewsDetailsBloc() : super(NewsDetailsInitial()) {
    on<NewsDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetNewsDetails>((event, emit) async {
      emit(NewsDetailsLoading());
      try {
        final result = await GetNewsByIdUseCase(repository: sl())(
          GetNewsByIdParams(id: event.id),
        );
        emit(NewsDetailsLoaded(news: result));
      } catch (e) {
        emit(NewsDetailsError(message: e.toString()));
      }
    });
  }
}
