import 'package:bytebank_persistence/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {

  Future<List<Place>> getPlaces(double lat, double lng, BitmapDescriptor icon) async {
    var key = 'AIzaSyAlbEKTNIZBg-mEFOsRyvEwaelHHU2mZS0';
    var types = 'atm';
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?rankby=distance&location=$lat,$lng&type=$types&key=$key');
    print('URL: $url');
    var response = await http.get(url);
    var json = await convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    jsonResults.forEach((result) => (result.forEach((key, value) {
      if (value is double) {
        if(value == null) value= 0;
      }
    })));
    return jsonResults.map((place) => Place.fromJson(place, icon)).toList();
  }

}