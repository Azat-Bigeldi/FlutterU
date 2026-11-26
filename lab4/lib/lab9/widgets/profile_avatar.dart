import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/settings/settings_cubit.dart';
import '../blocs/settings/settings_state.dart';
import '../services/media_service.dart';
import '../theme.dart';
import 'hardware_feedback.dart';

/// Фото профиля: нажатие открывает выбор камеры или галереи.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  Future<void> _change(BuildContext context, String? current) async {
    final media = context.read<MediaService>();
    final settings = context.read<SettingsCubit>();
    final action = await showPhotoSourceSheet(
      context,
      canRemove: current != null,
    );
    if (action == null || !context.mounted) return;

    String? name;
    if (action != PhotoAction.remove) {
      name = await pickPhoto(
        context,
        media,
        action == PhotoAction.camera ? ImageSource.camera : ImageSource.gallery,
        camera: CameraDevice.front,
      );
      if (name == null) return;
    }

    await settings.updateAvatar(name);
    if (current != null) await media.delete(current);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, String?>(
      selector: (state) => state.avatarName,
      builder: (context, avatarName) {
        final file = avatarName == null
            ? null
            : context.read<MediaService>().fileFor(avatarName);
        final hasPhoto = file != null && file.existsSync();

        return Semantics(
          button: true,
          label: 'Изменить фото профиля',
          child: GestureDetector(
            onTap: () => _change(context, avatarName),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: FlipColors.blue.withValues(alpha: 0.12),
                  backgroundImage: hasPhoto ? FileImage(file) : null,
                  child: hasPhoto
                      ? null
                      : const Icon(
                          Icons.person,
                          size: 36,
                          color: FlipColors.blue,
                        ),
                ),
                const Positioned(
                  right: -2,
                  bottom: -2,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: FlipColors.blue,
                    child: Icon(
                      Icons.photo_camera,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
