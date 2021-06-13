part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class OnMarkerActivated extends SearchEvent {}

class OnMarkerDeactivated extends SearchEvent {}
