import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  /// Fetches the current location coordinates with high accuracy.
  /// Automatically checks for location services status, requests permissions,
  /// and shows a themed bottom sheet if permissions are denied.
  static Future<Position> getCurrentLocationLtgLng(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verify if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    // Verify location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          await _showPermissionRequiredBottomSheet(context, permanentlyDenied: false);
        }
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        await _showPermissionRequiredBottomSheet(context, permanentlyDenied: true);
      }
      throw Exception('Location permissions are permanently denied');
    }

    // Retrieve high-accuracy location
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Resolves the given coordinates (or retrieves the current location if [position] is null)
  /// and converts it to a human-readable street address.
  static Future<String> getCurrentLocationLtgLngToAddress({
    required BuildContext context,
    Position? position,
  }) async {
    try {
      final targetPosition = position ?? await getCurrentLocationLtgLng(context);
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        targetPosition.latitude,
        targetPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts = [
          if (placemark.name != null && placemark.name != placemark.street) placemark.name,
          placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
          placemark.postalCode,
          placemark.country,
        ].where((part) => part != null && part.toString().trim().isNotEmpty).toList();

        return addressParts.join(', ');
      }
      return 'Address not found';
    } catch (e) {
      throw Exception('Failed to convert coordinates to address: $e');
    }
  }

  /// Displays an app-themed bottom sheet requesting location access.
  static Future<void> _showPermissionRequiredBottomSheet(
    BuildContext context, {
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
                      Icons.location_on_rounded,
                      size: 40.r,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Location Access Required',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    permanentlyDenied
                        ? 'Location permissions are permanently denied. Please enable them in your device settings to use this feature.'
                        : 'We need access to your location to provide this feature. Please grant the required location permission.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            if (permanentlyDenied) {
                              await Geolocator.openAppSettings();
                            } else {
                              await Geolocator.requestPermission();
                            }
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
