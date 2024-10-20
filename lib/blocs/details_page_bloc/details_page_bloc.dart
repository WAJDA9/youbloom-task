import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youbloom/models/person.dart';

part 'details_page_event.dart';
part 'details_page_state.dart';

class DetailsPageBloc extends Bloc<DetailsPageEvent, DetailsPageState> {
  DetailsPageBloc() : super(DetailsPageInitial()) {
    on<LoadPersonDetails>(_onLoadPersonDetails);
    on<GenerateGalacticFact>(_onGenerateGalacticFact);
  }

  void _onLoadPersonDetails(
      LoadPersonDetails event, Emitter<DetailsPageState> emit) {
    emit(DetailsPageLoaded(event.person));
  }

  void _onGenerateGalacticFact(
      GenerateGalacticFact event, Emitter<DetailsPageState> emit) {
    if (state is DetailsPageLoaded) {
      final currentState = state as DetailsPageLoaded;
      final starType = _getStarType();
      emit(DetailsPageLoaded(
        currentState.person,
        galacticFact:
            "If ${currentState.person.name} were a star, they would be a $starType!",
      ));
    }
  }

  String _getStarType() {
    final types = [
      'Red Dwarf',
      'Yellow Dwarf',
      'Blue Giant',
      'White Dwarf',
      'Neutron Star'
    ];
    return types[DateTime.now().microsecond % types.length];
  }
}
