import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

export 'package:share_plus/share_plus.dart' show XFile;

/// Share sheet helper with [sharePositionOrigin] resolution and iPad/macOS fallback.
abstract final class ShareHelper {
  static const _fallbackRect = Rect.fromLTWH(0, 0, 1, 1);

  static Rect? _rectFromContext(BuildContext? context) {
    if (context == null) {
      return null;
    }

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return null;
    }

    final position = box.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
      position.dx,
      position.dy,
      box.size.width,
      box.size.height,
    );
  }

  static Rect _resolveRect({
    Rect? sharePosition,
    BuildContext? anchorContext,
  }) {
    return sharePosition ?? _rectFromContext(anchorContext) ?? _fallbackRect;
  }

  static Future<ShareResult> shareText(
    String text, {
    String? subject,
    String? title,
    Rect? sharePosition,
    BuildContext? anchorContext,
  }) async {
    final rect = _resolveRect(
      sharePosition: sharePosition,
      anchorContext: anchorContext,
    );

    try {
      return SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
          title: title,
          sharePositionOrigin: rect,
        ),
      );
    } on PlatformException catch (error) {
      if (error.message?.contains('sharePositionOrigin') ?? false) {
        return SharePlus.instance.share(
          ShareParams(
            text: text,
            subject: subject,
            title: title,
            sharePositionOrigin: _fallbackRect,
          ),
        );
      }
      rethrow;
    }
  }

  static Future<ShareResult> shareUri(
    Uri uri, {
    String? subject,
    String? title,
    Rect? sharePosition,
    BuildContext? anchorContext,
  }) async {
    final rect = _resolveRect(
      sharePosition: sharePosition,
      anchorContext: anchorContext,
    );

    try {
      return SharePlus.instance.share(
        ShareParams(
          uri: uri,
          subject: subject,
          title: title,
          sharePositionOrigin: rect,
        ),
      );
    } on PlatformException catch (error) {
      if (error.message?.contains('sharePositionOrigin') ?? false) {
        return SharePlus.instance.share(
          ShareParams(
            uri: uri,
            subject: subject,
            title: title,
            sharePositionOrigin: _fallbackRect,
          ),
        );
      }
      rethrow;
    }
  }

  static Future<ShareResult> shareFiles({
    required List<XFile> files,
    String? text,
    String? subject,
    String? title,
    List<String>? fileNameOverrides,
    Rect? sharePosition,
    BuildContext? anchorContext,
  }) async {
    final rect = _resolveRect(
      sharePosition: sharePosition,
      anchorContext: anchorContext,
    );

    try {
      return SharePlus.instance.share(
        ShareParams(
          files: files,
          text: text,
          subject: subject,
          title: title,
          fileNameOverrides: fileNameOverrides,
          sharePositionOrigin: rect,
        ),
      );
    } on PlatformException catch (error) {
      if (error.message?.contains('sharePositionOrigin') ?? false) {
        return SharePlus.instance.share(
          ShareParams(
            files: files,
            text: text,
            subject: subject,
            title: title,
            fileNameOverrides: fileNameOverrides,
            sharePositionOrigin: _fallbackRect,
          ),
        );
      }
      rethrow;
    }
  }

  /// Shares a single file from disk (e.g. exported image).
  static Future<ShareResult> shareImage({
    required String filePath,
    String? subject,
    String? title,
    Rect? sharePosition,
    BuildContext? anchorContext,
  }) {
    return shareFiles(
      files: [XFile(filePath)],
      subject: subject,
      title: title,
      sharePosition: sharePosition,
      anchorContext: anchorContext,
    );
  }
}
