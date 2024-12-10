import 'package:location/location.dart';

class LocationService {
  Location _location = Location();
  double? latitude;
  double? longitude;

  Future<void> getLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      latitude = locationData.latitude;
      longitude = locationData.longitude;
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
