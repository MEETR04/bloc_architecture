import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandler {
  AppPermissionHandler._();

  /// Requests the given [Permission] and returns a boolean indicating success.
  /// If the permission is denied, it shows a custom, app-themed bottom sheet prompting the user.
  static Future<bool> requestPermission(
    BuildContext context,
    Permission permission, {
    required String title,
    required String description,
    IconData icon = Icons.security_rounded,
  }) async {
    PermissionStatus status = await permission.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    // Request permission
    status = await permission.request();

    if (status.isGranted || status.isLimited) {
      return true;
    }

    // If permanently denied or denied, show the themed bottom sheet
    if (context.mounted) {
      final permanentlyDenied = status.isPermanentlyDenied;
      await _showPermissionRequiredBottomSheet(
        context,
        title: title,
        description: description,
        icon: icon,
        permanentlyDenied: permanentlyDenied,
      );
    }

    return false;
  }

  /// Specific helper to check/request Camera permission.
  static Future<bool> requestCamera(BuildContext context) => requestPermission(
        context,
        Permission.camera,
        title: 'Camera Access Required',
        description: 'We need access to your camera to capture photos. Please enable camera access in your settings.',
        icon: Icons.camera_alt_rounded,
      );

  /// Specific helper to check/request Microphone permission.
  static Future<bool> requestMicrophone(BuildContext context) => requestPermission(
        context,
        Permission.microphone,
        title: 'Microphone Access Required',
        description: 'We need access to your microphone to record audio. Please enable microphone access in your settings.',
        icon: Icons.mic_rounded,
      );

  /// Specific helper to check/request Location permission.
  static Future<bool> requestLocation(BuildContext context) => requestPermission(
        context,
        Permission.locationWhenInUse,
        title: 'Location Access Required',
        description: 'We need access to your location to provide core features. Please enable location access in your settings.',
        icon: Icons.location_on_rounded,
      );

  /// Specific helper to check/request Photos/Gallery permission.
  static Future<bool> requestPhotos(BuildContext context) => requestPermission(
        context,
        Permission.photos,
        title: 'Photos Access Required',
        description: 'We need access to your photo library to select images. Please enable photos access in your settings.',
        icon: Icons.photo_library_rounded,
      );

  /// Specific helper to check/request Storage permission.
  static Future<bool> requestStorage(BuildContext context) => requestPermission(
        context,
        Permission.storage,
        title: 'Storage Access Required',
        description: 'We need access to your device storage to save/retrieve files. Please enable storage access in your settings.',
        icon: Icons.folder_rounded,
      );

  /// Displays an app-themed bottom sheet requesting permission access.
  static Future<void> _showPermissionRequiredBottomSheet(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool permanentlyDenied,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 40.r,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  16.verticalSpace,
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  8.verticalSpace,
                  Text(
                    permanentlyDenied
                        ? '$description Please enable it in your device settings.'
                        : description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await openAppSettings();
                          },
                          child: Text(permanentlyDenied ? 'Settings' : 'Grant'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
