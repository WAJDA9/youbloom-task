part of 'details_page_bloc.dart';

@immutable
sealed class DetailsPageState {}

final class DetailsPageInitial extends DetailsPageState {}

class DetailsPageLoaded extends DetailsPageState {
  final Person person;
  final String? galacticFact;

  DetailsPageLoaded(this.person, {this.galacticFact});
}
