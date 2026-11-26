import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaException implements Exception {
  final String message;

  /// true, если исправить можно только в настройках системы.
  final bool needsSettings;

  const MediaException(this.message, {this.needsSettings = false});
}

/// Камера, галерея и хранение выбранных фото внутри приложения.
class MediaService {
  final Directory directory;
  final ImagePicker _picker = ImagePicker();

  MediaService(this.directory);

  File fileFor(String name) => File('${directory.path}/$name');

  /// Возвращает имя сохранённого файла или null, если пользователь отменил.
  Future<String?> pickAndStore(
    ImageSource source, {
    CameraDevice camera = CameraDevice.rear,
  }) async {
    try {
      if (source == ImageSource.camera) await _ensureCameraPermission();

      // Для галереи разрешение не запрашиваем: системное окно выбора
      // отдаёт приложению только выбранный снимок.
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1080,
        preferredCameraDevice: camera,
      );
      if (picked == null) return null;

      // image_picker кладёт файл во временную папку, поэтому копируем его.
      await directory.create(recursive: true);
      final dot = picked.path.lastIndexOf('.');
      final extension = dot == -1 ? '.jpg' : picked.path.substring(dot);
      final name = '${DateTime.now().microsecondsSinceEpoch}$extension';
      await File(picked.path).copy(fileFor(name).path);
      return name;
    } on PlatformException catch (e) {
      throw MediaException(
        source == ImageSource.camera
            ? 'Камера недоступна: ${e.message ?? e.code}'
            : 'Не удалось открыть галерею: ${e.message ?? e.code}',
      );
    } on FileSystemException {
      throw const MediaException('Не удалось сохранить фото на устройстве');
    }
  }

  Future<void> delete(String name) async {
    final file = fileFor(name);
    if (await file.exists()) await file.delete();
  }

  Future<void> openSettings() => openAppSettings();

  Future<void> _ensureCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) return;

    if (status.isPermanentlyDenied || status.isRestricted) {
      throw const MediaException(
        'Доступ к камере запрещён. Разрешите его в настройках.',
        needsSettings: true,
      );
    }
    throw const MediaException('Без разрешения камера не откроется');
  }
}
