import 'package:app/features/news/domain/entities/news_entity.dart';
import 'package:app/features/news/data/mock/mock_news.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 500));

        // Get news by ID from mock data
        final result = MockNews.getNewsById(event.id);

        if (result == null) {
          emit(const NewsDetailsError(message: 'News article not found'));
        } else {
          emit(NewsDetailsLoaded(news: result));
        }
      } catch (e) {
        emit(NewsDetailsError(message: e.toString()));
      }
    });
  }
}
