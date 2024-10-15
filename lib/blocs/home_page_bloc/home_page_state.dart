part of 'home_page_bloc.dart';

@immutable
sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

final class HomePageLoading extends HomePageState {}

final class HomePageError extends HomePageState {
  final String error;
  HomePageError(this.error);
}

final class HomePageSuccess extends HomePageState {}

final class DataLoaded extends HomePageState {
  final List<dynamic> data;
  DataLoaded(this.data);
}
