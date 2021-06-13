part of 'marker_bloc.dart';



@immutable
abstract class PointsState {}

class PointsInitial extends PointsState {}

class PointsLoading extends PointsState {}

class PointsError extends PointsState {
  final String message;

  PointsError(this.message);
}

class PointsCompleted extends PointsState {
  final List<MapMarker> coordinates;

  final int selectedItem;

  PointsCompleted(this.coordinates, {this.selectedItem});

  PointsCompleted copyWith({
    List<MapMarker> coordinates,
    int selectedItem,
  }) {
    return PointsCompleted(coordinates ?? this.coordinates,
        selectedItem: selectedItem ?? this.selectedItem);
  }
}
