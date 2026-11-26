import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/location_service.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationService service;

  LocationCubit(this.service) : super(const LocationInitial());

  Future<void> fetch() async {
    if (state is LocationLoading) return;
    emit(const LocationLoading());
    try {
      final fix = await service.currentFix();
      if (!isClosed) emit(LocationSuccess(fix));
    } on LocationException catch (e) {
      if (!isClosed) emit(LocationFailure(e.problem));
    } catch (_) {
      if (!isClosed) {
        emit(const LocationFailure(LocationProblem.unavailable));
      }
    }
  }

  void reset() => emit(const LocationInitial());
}
