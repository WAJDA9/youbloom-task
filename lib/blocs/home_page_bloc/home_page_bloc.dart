import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:youbloom/const/globals.dart';
import 'package:youbloom/repositories/people_repository.dart';
import 'package:youbloom/services/api_service.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<FetchHomeScreenData>(_fetchHomeScreenData);
  }

  void _fetchHomeScreenData(
      FetchHomeScreenData event, Emitter<HomePageState> emit) async {
    emit(HomePageLoading());
    try {
      await PeopleRepository().FetchPeople();
      emit(DataLoaded(people));
    } catch (e) {
      emit(HomePageError(e.toString()));
    }
  }
}
