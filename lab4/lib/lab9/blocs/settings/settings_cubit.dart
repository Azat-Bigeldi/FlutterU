import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local_storage_service.dart';
import '../../models/location_fix.dart';
import '../../models/note_item.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(super.initialState);

  Future<void> updateTheme(bool value) async {
    emit(state.copyWith(isDarkMode: value));
    await LocalStorageService.saveDarkMode(value);
  }

  Future<void> updateDisplayName(String value) async {
    final cleanedName = value.trim().isEmpty ? 'Guest User' : value.trim();
    emit(state.copyWith(displayName: cleanedName));
    await LocalStorageService.saveDisplayName(cleanedName);
  }

  Future<void> updateNotes(List<NoteItem> value) async {
    final updatedNotes = List<NoteItem>.unmodifiable(value);
    emit(state.copyWith(notes: updatedNotes));
    await LocalStorageService.saveNotes(updatedNotes);
  }

  /// null удаляет фото профиля.
  Future<void> updateAvatar(String? name) async {
    emit(state.copyWith(avatarName: name, removeAvatar: name == null));
    await LocalStorageService.saveAvatarName(name);
  }

  Future<void> updateDeliveryPoint(LocationFix point) async {
    emit(state.copyWith(deliveryPoint: point));
    await LocalStorageService.saveDeliveryPoint(point);
  }
}
