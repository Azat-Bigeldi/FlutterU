import 'package:equatable/equatable.dart';

import '../../models/location_fix.dart';
import '../../services/location_service.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationSuccess extends LocationState {
  final LocationFix fix;

  const LocationSuccess(this.fix);

  @override
  List<Object?> get props => [fix];
}

class LocationFailure extends LocationState {
  final LocationProblem problem;

  const LocationFailure(this.problem);

  @override
  List<Object?> get props => [problem];
}
