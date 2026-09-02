import 'package:bloc_architecture/service/app_permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  /// Fetches the current location coordinates with high accuracy.
  /// Automatically checks for location services status, requests permissions
  /// via [AppPermissionHandler], and retrieves the device position.
  static Future<Position> getCurrentLocationLtgLng(BuildContext context) async {
    bool serviceEnabled;

    // Verify if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    // Verify location permissions using the unified permission handler
    if (!context.mounted) {
      throw Exception('Context is no longer mounted');
    }
    final bool permissionGranted = await AppPermissionHandler.requestLocation(
      context,
    );
    if (!permissionGranted) {
      throw Exception('Location permissions are denied');
    }

    // Retrieve high-accuracy location
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  /// Resolves the given coordinates (or retrieves the current location if [position] is null)
  /// and converts it to a human-readable street address.
  static Future<String> getCurrentLocationLtgLngToAddress({
    required BuildContext context,
    Position? position,
  }) async {
    try {
      final targetPosition =
          position ?? await getCurrentLocationLtgLng(context);
      final List<Placemark> placemarks = await Geocoding()
          .placemarkFromCoordinates(
            targetPosition.latitude,
            targetPosition.longitude,
          );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts =
            [
                  if (placemark.name != null &&
                      placemark.name != placemark.street)
                    placemark.name,
                  placemark.street,
                  placemark.subLocality,
                  placemark.locality,
                  placemark.administrativeArea,
                  placemark.postalCode,
                  placemark.country,
                ]
                .where(
                  (part) => part != null && part.toString().trim().isNotEmpty,
                )
                .toList();

        return addressParts.join(', ');
      }
      return 'Address not found';
    } catch (e) {
      throw Exception('Failed to convert coordinates to address: $e');
    }
  }
}
