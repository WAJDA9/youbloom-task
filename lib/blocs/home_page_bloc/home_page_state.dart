part of 'home_page_bloc.dart';

@immutable
sealed class HomePageState {
  final List<Person> people;
  final bool hasReachedMax;
  const HomePageState(
      {this.people = const <Person>[], this.hasReachedMax = false});
}

final class HomePageInitial extends HomePageState {}

final class HomePageLoading extends HomePageState {
   final List<Person> people;
  final bool hasReachedMax;

  const HomePageLoading({required this.people, required this.hasReachedMax})
      : super(people: people, hasReachedMax: hasReachedMax);
}

final class HomePageError extends HomePageState {
  final String error;
  HomePageError(this.error);
}

final class HomePageSuccess extends HomePageState {}

final class DataLoaded extends HomePageState {
   final List<Person> people;
  final bool hasReachedMax;

  const DataLoaded({required this.people, required this.hasReachedMax})
      : super(people: people, hasReachedMax: hasReachedMax);
}
