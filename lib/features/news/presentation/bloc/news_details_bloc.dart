import 'package:app/features/news/domain/entities/news_entity.dart';
import 'package:app/features/news/domain/repositories/news_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_details_event.dart';
part 'news_details_state.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  final NewsRepository repository;

  NewsDetailsBloc({required this.repository}) : super(NewsDetailsInitial()) {
    on<GetNewsDetails>((event, emit) async {
      emit(NewsDetailsLoading());
      try {
        final result = await repository.getNewsById(event.id);
        emit(NewsDetailsLoaded(news: result));
      } catch (e) {
        emit(NewsDetailsError(message: e.toString()));
      }
    });
  }
}
