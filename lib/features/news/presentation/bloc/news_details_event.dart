part of 'news_details_bloc.dart';

sealed class NewsDetailsEvent extends Equatable {
  const NewsDetailsEvent();
}

class GetNewsDetails extends NewsDetailsEvent {
  final String id;

  const GetNewsDetails({required this.id});

  @override
  List<Object?> get props => [id];
}
