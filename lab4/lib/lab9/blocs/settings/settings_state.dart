import 'package:equatable/equatable.dart';

import '../../models/location_fix.dart';
import '../../models/note_item.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final String displayName;
  final List<NoteItem> notes;

  /// Имя файла фото профиля.
  final String? avatarName;
  final LocationFix? deliveryPoint;

  const SettingsState({
    required this.isDarkMode,
    required this.displayName,
    required this.notes,
    this.avatarName,
    this.deliveryPoint,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? displayName,
    List<NoteItem>? notes,
    String? avatarName,
    bool removeAvatar = false,
    LocationFix? deliveryPoint,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      displayName: displayName ?? this.displayName,
      notes: notes ?? this.notes,
      avatarName: removeAvatar ? null : avatarName ?? this.avatarName,
      deliveryPoint: deliveryPoint ?? this.deliveryPoint,
    );
  }

  @override
  List<Object?> get props => [
    isDarkMode,
    displayName,
    notes,
    avatarName,
    deliveryPoint,
  ];
}
