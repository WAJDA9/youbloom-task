

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'details_page_event.dart';
part 'details_page_state.dart';

class DetailsPageBloc extends Bloc<DetailsPageEvent, DetailsPageState> {
  DetailsPageBloc() : super(DetailsPageInitial()) {
    on<DetailsPageEvent>((event, emit) {
      
    });
  }
}
