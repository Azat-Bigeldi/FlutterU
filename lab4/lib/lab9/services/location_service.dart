import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../models/location_fix.dart';

enum LocationProblem { serviceDisabled, denied, deniedForever, unavailable }

class LocationException implements Exception {
  final LocationProblem problem;

  const LocationException(this.problem);
}

class LocationService {
  Future<LocationFix> currentFix() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationProblem.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(LocationProblem.denied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationProblem.deniedForever);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return LocationFix(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp.toLocal(),
      );
    } on LocationServiceDisabledException {
      throw const LocationException(LocationProblem.serviceDisabled);
    } catch (_) {
      // Тайм-аут или нет сигнала.
      throw const LocationException(LocationProblem.unavailable);
    }
  }

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  Future<void> openAppSettings() => Geolocator.openAppSettings();
}
