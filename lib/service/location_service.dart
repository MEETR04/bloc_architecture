import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  /// Fetches the current location coordinates with high accuracy.
  /// Automatically checks for location services status and requests permissions if necessary.
  static Future<Position> getCurrentLocationLtgLng() async {
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
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
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
  static Future<String> getCurrentLocationLtgLngToAddress({Position? position}) async {
    try {
      final targetPosition = position ?? await getCurrentLocationLtgLng();
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
}
