part of 'home_page_bloc.dart';

@immutable
sealed class HomePageEvent {}

class FetchHomeScreenData extends HomePageEvent {
  final bool isInitialFetch;
  final String? searchQuery;

  FetchHomeScreenData({this.isInitialFetch = true, this.searchQuery});
}
