part of 'details_page_bloc.dart';

@immutable
sealed class DetailsPageEvent {}

class LoadPersonDetails extends DetailsPageEvent {
  final Person person;
  LoadPersonDetails(this.person);
}

class GenerateGalacticFact extends DetailsPageEvent {}
