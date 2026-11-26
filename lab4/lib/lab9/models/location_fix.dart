import 'package:equatable/equatable.dart';

/// Одно измерение GPS.
class LocationFix extends Equatable {
  final double latitude;
  final double longitude;
  final double altitude;

  /// Погрешность по горизонтали в метрах.
  final double accuracy;
  final DateTime timestamp;

  const LocationFix({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    required this.timestamp,
  });

  String get shortText {
    final lat =
        '${latitude.abs().toStringAsFixed(4)}° '
        '${latitude >= 0 ? 'N' : 'S'}';
    final lon =
        '${longitude.abs().toStringAsFixed(4)}° '
        '${longitude >= 0 ? 'E' : 'W'}';
    return '$lat, $lon';
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'altitude': altitude,
    'accuracy': accuracy,
    'timestamp': timestamp.toIso8601String(),
  };

  factory LocationFix.fromJson(Map<String, dynamic> json) => LocationFix(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    altitude: (json['altitude'] as num).toDouble(),
    accuracy: (json['accuracy'] as num).toDouble(),
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    altitude,
    accuracy,
    timestamp,
  ];
}
