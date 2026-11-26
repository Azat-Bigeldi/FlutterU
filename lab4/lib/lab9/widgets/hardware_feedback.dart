import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/location_service.dart';
import '../services/media_service.dart';

enum PhotoAction { camera, gallery, remove }

/// Нижнее меню выбора источника фото.
Future<PhotoAction?> showPhotoSourceSheet(
  BuildContext context, {
  bool canRemove = false,
}) {
  return showModalBottomSheet<PhotoAction>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      Widget tile(IconData icon, String title, PhotoAction action) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => Navigator.pop(sheetContext, action),
      );

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            tile(
              Icons.photo_camera_outlined,
              'Сделать фото',
              PhotoAction.camera,
            ),
            tile(
              Icons.photo_library_outlined,
              'Выбрать из галереи',
              PhotoAction.gallery,
            ),
            if (canRemove)
              tile(Icons.delete_outline, 'Удалить фото', PhotoAction.remove),
          ],
        ),
      );
    },
  );
}

/// Выбор фото с показом ошибок. null — отмена или ошибка.
Future<String?> pickPhoto(
  BuildContext context,
  MediaService media,
  ImageSource source, {
  CameraDevice camera = CameraDevice.rear,
}) async {
  try {
    return await media.pickAndStore(source, camera: camera);
  } on MediaException catch (e) {
    if (!context.mounted) return null;
    if (e.needsSettings) {
      await _askToOpenSettings(
        context,
        title: 'Нет доступа к камере',
        message: e.message,
        onOpen: media.openSettings,
      );
    } else {
      _showMessage(context, e.message);
    }
    return null;
  }
}

Future<void> showLocationProblem(
  BuildContext context,
  LocationService service,
  LocationProblem problem,
) async {
  switch (problem) {
    case LocationProblem.serviceDisabled:
      await _askToOpenSettings(
        context,
        title: 'GPS выключен',
        message: 'Включите службы геолокации на устройстве.',
        onOpen: service.openLocationSettings,
      );
    case LocationProblem.deniedForever:
      await _askToOpenSettings(
        context,
        title: 'Нет доступа к геопозиции',
        message: 'Разрешите доступ к геопозиции в настройках приложения.',
        onOpen: service.openAppSettings,
      );
    case LocationProblem.denied:
      _showMessage(context, 'Без разрешения нельзя определить местоположение');
    case LocationProblem.unavailable:
      _showMessage(context, 'Не удалось получить GPS. Попробуйте ещё раз');
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> _askToOpenSettings(
  BuildContext context, {
  required String title,
  required String message,
  required Future<void> Function() onOpen,
}) async {
  final open = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Открыть настройки'),
        ),
      ],
    ),
  );
  if (open == true) await onOpen();
}
