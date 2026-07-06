import 'dart:io';

import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

enum SelectionType { single, multiple }

enum PickedFileType { image, video, file }

enum SourceType { camera, gallery }

class MediaPickerSheet extends StatelessWidget {
  const MediaPickerSheet({
    super.key,
    required this.pickFileType,
    required this.selectionType,
    required this.onSelectFile,
    required this.isCropEnable,
    this.need16x9AspectRatioLocked = false,
    this.isAllowDoc = false,
    this.needVideo = false,
  });

  final PickedFileType pickFileType;
  final SelectionType selectionType;
  final void Function(List<XFile>?, PickedFileType) onSelectFile;
  final bool isCropEnable;
  final bool? need16x9AspectRatioLocked;

  /// When true, a "Documents" button is shown that lets the user pick
  /// PDF / Word / Excel / text files via file_picker.
  final bool isAllowDoc;

  /// When true, a "Video" button is shown that lets the user pick a video
  /// from the gallery (max 60 s).
  final bool needVideo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Camera button
              GestureDetector(
                onTap: () async {
                  final parentContext = await _dismissSheetAndGetParentContext(context);
                  if (!parentContext.mounted) return;
                  await selectMedia(
                    need16x9CropRatioLocked: need16x9AspectRatioLocked,
                    context: parentContext,
                    sourceType: SourceType.camera,
                    pickFileType: pickFileType,
                    onSelectFile: onSelectFile,
                    selectionType: selectionType,
                    isCropEnable: isCropEnable,
                  );
                },
                child: _RoundedButton(
                  buttonLabel: 'Camera',
                  bgColor: theme.colorScheme.primaryContainer,
                  textColor: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              12.verticalSpace,

              // Gallery button
              GestureDetector(
                onTap: () async {
                  final parentContext = await _dismissSheetAndGetParentContext(context);
                  if (!parentContext.mounted) return;
                  await selectMedia(
                    need16x9CropRatioLocked: need16x9AspectRatioLocked,
                    context: parentContext,
                    selectionType: selectionType,
                    sourceType: SourceType.gallery,
                    pickFileType: pickFileType,
                    onSelectFile: onSelectFile,
                    isCropEnable: isCropEnable,
                  );
                },
                child: _RoundedButton(
                  buttonLabel: 'Gallery',
                  bgColor: theme.colorScheme.primaryContainer,
                  textColor: theme.colorScheme.onPrimaryContainer,
                ),
              ),

              // Documents button (optional)
              if (isAllowDoc) ...[
                12.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      final FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: [
                          'pdf',
                          'doc',
                          'docx',
                          'xls',
                          'xlsx',
                          'txt',
                        ],
                      );
                      if (result != null && result.files.single.path != null) {
                        onSelectFile([
                          XFile(result.files.single.path!),
                        ], PickedFileType.file);
                      }
                    } catch (e) {
                      debugPrint('Error picking document: $e');
                    }
                  },
                  child: _RoundedButton(
                    buttonLabel: 'Documents',
                    bgColor: theme.colorScheme.secondaryContainer,
                    textColor: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],

              // Video button (optional)
              if (needVideo) ...[
                12.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    final parentContext = await _dismissSheetAndGetParentContext(context);
                    if (!parentContext.mounted) return;
                    await selectMedia(
                      context: parentContext,
                      sourceType: SourceType.gallery,
                      pickFileType: PickedFileType.video,
                      onSelectFile: onSelectFile,
                      selectionType: SelectionType.single,
                      isCropEnable: false,
                    );
                  },
                  child: _RoundedButton(
                    buttonLabel: 'Video',
                    bgColor: theme.colorScheme.secondaryContainer,
                    textColor: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],

              12.verticalSpace,

              // Cancel button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: _RoundedButton(
                  buttonLabel: 'Cancel',
                  bgColor: theme.colorScheme.surfaceContainerHighest,
                  textColor: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              12.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Future<BuildContext> _dismissSheetAndGetParentContext(
    BuildContext sheetContext,
  ) async {
    Navigator.pop(sheetContext);
    if (Platform.isAndroid) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    return sheetContext;
  }

  Future<void> selectMedia({
    required BuildContext context,
    required SourceType sourceType,
    required PickedFileType pickFileType,
    required SelectionType selectionType,
    required void Function(List<XFile>?, PickedFileType) onSelectFile,
    required bool isCropEnable,
    bool? need16x9CropRatioLocked = false,
  }) async {
    // 1. Check / request permission first
    final bool granted = await _checkAndRequestPermission(
      sourceType: sourceType,
      pickFileType: pickFileType,
      context: context,
    );
    if (!granted) return;

    // 2. Pick file(s)
    List<XFile>? files;

    switch (sourceType) {
      // Camera
      case SourceType.camera:
        if (pickFileType == PickedFileType.image) {
          try {
            final XFile? pickedFile = await ImagePicker().pickImage(
              source: ImageSource.camera,
              imageQuality: 30,
            );
            debugPrint(
              'Camera image pick result: ${pickedFile?.path ?? "null"}',
            );
            if (pickedFile == null) return;

            final XFile? finalFile = await _compressIfNeeded(
              pickedFile,
              pickFileType,
            );
            files = finalFile != null ? [finalFile] : null;
          } catch (e) {
            debugPrint('Error picking camera image: $e');
            return;
          }
        } else {
          try {
            final XFile? file = await ImagePicker().pickVideo(
              source: ImageSource.camera,
              maxDuration: const Duration(seconds: 60),
            );
            debugPrint('Camera video pick result: ${file?.path ?? "null"}');
            files = file != null ? [file] : null;
          } catch (e) {
            debugPrint('Error picking camera video: $e');
            return;
          }
        }
        break;

      // Gallery
      case SourceType.gallery:
        if (pickFileType == PickedFileType.image) {
          try {
            List<XFile> pickedFiles;
            if (selectionType == SelectionType.multiple) {
              pickedFiles = await ImagePicker().pickMultiImage(
                imageQuality: 30,
              );
            } else {
              final XFile? f = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                imageQuality: 30,
              );
              debugPrint('Gallery image pick result: ${f?.path ?? "null"}');
              if (f == null) return;
              pickedFiles = [f];
            }

            if (pickedFiles.isEmpty) return;

            final List<XFile> processed = [];
            for (XFile pickedFile in pickedFiles) {
              final XFile? finalFile = await _compressIfNeeded(
                pickedFile,
                pickFileType,
              );
              if (finalFile != null) processed.add(finalFile);
            }

            files = processed.isNotEmpty ? processed : null;
          } catch (e) {
            debugPrint('Error picking gallery image: $e');
            return;
          }
        } else {
          try {
            final XFile? file = await ImagePicker().pickVideo(
              source: ImageSource.gallery,
              maxDuration: const Duration(seconds: 60),
            );
            debugPrint('Gallery video pick result: ${file?.path ?? "null"}');
            files = file != null ? [file] : null;
          } catch (e) {
            debugPrint('Error picking gallery video: $e');
            return;
          }
        }
        break;
    }

    onSelectFile(files, pickFileType);
  }

  Future<XFile?> _compressIfNeeded(
    XFile file,
    PickedFileType pickFileType,
  ) async {
    if (pickFileType != PickedFileType.image) return file;

    try {
      final int fileSizeKB = await _getFileSizeInKB(filePath: file.path);
      debugPrint('File size: ${fileSizeKB}KB — path: ${file.path}');

      if (fileSizeKB > 150) {
        final XFile compressed = await _compressImage(file);
        debugPrint('Compressed file path: ${compressed.path}');
        return compressed;
      }
    } catch (e) {
      debugPrint('Error while compressing image: $e');
    }

    return file;
  }

  Future<int> _getFileSizeInKB({required String filePath}) async {
    final file = File(filePath);
    if (await file.exists()) {
      final int bytes = await file.length();
      return (bytes / 1024).round();
    }
    throw Exception('File does not exist: $filePath');
  }

  Future<XFile> _compressImage(XFile file) async {
    final String fileName = p.basenameWithoutExtension(file.path);
    final String targetPath = p.join(
      Directory.systemTemp.path,
      '${fileName}_compressed.jpg',
    );

    final XFile? compressedImage =
        await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 10,
      format: CompressFormat.jpeg,
    );

    if (compressedImage == null) {
      throw Exception('Failed to compress image: ${file.path}');
    }

    return compressedImage;
  }

  Future<bool> _checkAndRequestPermission({
    required SourceType sourceType,
    required PickedFileType pickFileType,
    required BuildContext context,
  }) async {
    // Camera
    if (sourceType == SourceType.camera) {
      final List<Permission> permissions = [
        Permission.camera,
        if (pickFileType == PickedFileType.video) Permission.microphone,
      ];

      final Map<Permission, PermissionStatus> statuses =
          await permissions.request();

      final bool allGranted = statuses.values.every(
        (s) => s.isGranted || s.isLimited,
      );

      if (!allGranted && context.mounted) {
        if (statuses.values.any((s) => s.isPermanentlyDenied)) {
          _showSettingsDialog(context);
        }
      }
      return allGranted;
    }

    // Gallery
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final int sdkVersion = androidInfo.version.sdkInt;

      if (sdkVersion >= 33) {
        return true;
      } else {
        final PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted && context.mounted) {
          if (status.isPermanentlyDenied) _showSettingsDialog(context);
        }
        return status.isGranted;
      }
    }

    // iOS
    if (Platform.isIOS) {
      final PermissionStatus status = await Permission.photos.request();
      final bool granted = status.isGranted || status.isLimited;
      if (!granted && context.mounted) {
        if (status.isPermanentlyDenied) _showSettingsDialog(context);
      }
      return granted;
    }

    return true;
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please allow the required permission from Settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

class _RoundedButton extends StatelessWidget {
  const _RoundedButton({
    required this.buttonLabel,
    required this.bgColor,
    required this.textColor,
  });

  final String buttonLabel;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(100.r)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 2),
              blurRadius: 4.r,
            ),
          ],
        ),
        child: Text(
          buttonLabel,
          style: AppTextStyle.labelLarge.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

bool isImageFile(String filePath) {
  const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
  return imageExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
}

bool isVideoFile(String filePath) {
  const videoExtensions = ['.mp4', '.mkv', '.avi', '.mov', '.webm'];
  return videoExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
}

bool isDocFile(String filePath) {
  const docExtensions = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.txt'];
  return docExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
}
