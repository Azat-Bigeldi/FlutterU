import 'package:equatable/equatable.dart';

import 'location_fix.dart';

class JournalEntry extends Equatable {
  final String id;

  /// Только имя файла: на iOS путь к папке приложения может меняться.
  final String photoName;
  final String caption;
  final DateTime takenAt;
  final LocationFix location;

  const JournalEntry({
    required this.id,
    required this.photoName,
    required this.caption,
    required this.takenAt,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'photoName': photoName,
    'caption': caption,
    'takenAt': takenAt.toIso8601String(),
    'location': location.toJson(),
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'] as String,
    photoName: json['photoName'] as String,
    caption: json['caption'] as String,
    takenAt: DateTime.parse(json['takenAt'] as String),
    location: LocationFix.fromJson(
      Map<String, dynamic>.from(json['location'] as Map),
    ),
  );

  @override
  List<Object?> get props => [id, photoName, caption, takenAt, location];
}
