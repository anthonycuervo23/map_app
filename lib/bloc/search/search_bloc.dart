import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(event) async* {
    if (event is OnMarkerActivated) {
      yield state.copyWith(manualSelection: true);
    } else if (event is OnMarkerDeactivated) {
      yield state.copyWith(manualSelection: false);
    }
  }
}
