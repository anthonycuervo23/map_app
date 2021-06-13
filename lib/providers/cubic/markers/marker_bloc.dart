import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

//My imports
import 'package:map_app/models/marker.dart';
import 'package:map_app/services/marker_repository.dart';

part 'marker_state.dart';

class PointsCubit extends Cubit<PointsState> {
  PointsCubit(this.mapService) : super(PointsInitial());

  final MarkerRepository mapService;

  Future<void> fetchPoints() async {
    final responseItems = await mapService.getMarker();
    if (responseItems != null)
      emit(PointsCompleted(responseItems, selectedItem: 0));
    else
      emit(PointsError("Data Not Found"));
  }

  Future<void> fetchPointsCustomMarker() async {
    final responseItems = await mapService.getMarker();
    if (responseItems != null)
      emit(PointsCompleted(responseItems, selectedItem: 0));
    else
      emit(PointsError("Data Not Found"));
  }

  void changeSelectedCoordinate(int index, List<MapMarker> items) {
    final _state = state as PointsCompleted;
    emit(_state.copyWith(selectedItem: index));
  }
}
