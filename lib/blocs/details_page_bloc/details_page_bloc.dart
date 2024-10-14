import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'details_page_event.dart';
part 'details_page_state.dart';

class DetailsPageBloc extends Bloc<DetailsPageEvent, DetailsPageState> {
  DetailsPageBloc() : super(DetailsPageInitial()) {
    on<DetailsPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
