import 'package:geolocator/geolocator.dart';

class GeoLocatorService{

  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true
    );
  }

  getDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

}