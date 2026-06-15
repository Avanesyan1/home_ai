import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract final class GalleryHelper {
  static Future<String> get _generationsDirectory async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final directory = Directory(
      p.join(documentsDirectory.path, 'generations'),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

  static Future<String?> persistImageFile(
    String sourcePath, {
    required String filename,
  }) async {
    try {
      final source = File(sourcePath);
      if (!await source.exists()) {
        return null;
      }

      final targetPath = p.join(await _generationsDirectory, filename);
      await source.copy(targetPath);
      return targetPath;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> persistImageBytes(
    Uint8List imageBytes, {
    required String filename,
  }) async {
    try {
      final targetPath = p.join(await _generationsDirectory, filename);
      await File(targetPath).writeAsBytes(imageBytes);
      return targetPath;
    } catch (_) {
      return null;
    }
  }
  static Future<bool> saveImageToGallery(
    Uint8List imageBytes, {
    String? filename,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/${filename ?? 'home_ai_${DateTime.now().millisecondsSinceEpoch}.jpg'}';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      final result = await ImageGallerySaver.saveFile(filePath);

      if (await file.exists()) {
        await file.delete();
      }

      return result['isSuccess'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> saveImageFileToGallery(String filePath) async {
    try {
      if (!await File(filePath).exists()) {
        return false;
      }

      final result = await ImageGallerySaver.saveFile(filePath);
      return result['isSuccess'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> writeTemporaryImage(
    Uint8List imageBytes, {
    String? filename,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/${filename ?? 'home_ai_${DateTime.now().millisecondsSinceEpoch}.jpg'}';
      await File(filePath).writeAsBytes(imageBytes);
      return filePath;
    } catch (_) {
      return null;
    }
  }
}
