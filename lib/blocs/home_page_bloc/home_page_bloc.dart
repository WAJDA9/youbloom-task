
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youbloom/models/person.dart';
import 'package:youbloom/repositories/people_repository.dart';
import 'package:rxdart/rxdart.dart';
part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  int currentPage = 1;
  final int peoplePerPage = 10;
  String? currentSearchQuery;
  HomePageBloc() : super(HomePageInitial()) {
    on<FetchHomeScreenData>(_fetchHomeScreenData,
        transformer: _throttleDroppable(const Duration(milliseconds: 500)));
  }
  EventTransformer<E> _throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return events.throttleTime(duration).switchMap(mapper);
    };
  }

  void _fetchHomeScreenData(
      FetchHomeScreenData event, Emitter<HomePageState> emit) async {
    if (state.hasReachedMax && !event.isInitialFetch) return;

    try {
      if (event.isInitialFetch) {
        currentPage = 1;
        currentSearchQuery = event.searchQuery;
        emit(const HomePageLoading(people: [], hasReachedMax: false));
      } else {
        emit(HomePageLoading(
            people: state.people, hasReachedMax: state.hasReachedMax));
      }

      final peopleResults = await PeopleRepository().fetchPeople(
        page: currentPage,
       // searchQuery: currentSearchQuery,
      );
      final fetchedPeople = peopleResults.results;

      final totalpeople = peopleResults.count;

      final hasReachedMax =
          (state.people.length + fetchedPeople.length) >= totalpeople;

      if (event.isInitialFetch) {
        emit(DataLoaded(
          people: fetchedPeople,
          hasReachedMax: hasReachedMax,
        ));
      } else {
        emit(DataLoaded(
          people: List.of(state.people)..addAll(fetchedPeople),
          hasReachedMax: hasReachedMax,
        ));
      }

      if (!hasReachedMax) currentPage++;
      
    } catch (e) {
      emit(HomePageError(e.toString()));
    }
  }
}
