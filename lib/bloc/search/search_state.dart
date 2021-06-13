part of 'search_bloc.dart';

@immutable
class SearchState {
  final bool manualSelection;

  SearchState({this.manualSelection = false});

  SearchState copyWith({bool manualSelection}) {
    return SearchState(
        manualSelection: manualSelection ?? this.manualSelection);
  }
}
