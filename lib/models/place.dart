import 'package:bytebank_persistence/models/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place{
  final String name;
  final bool open;
  //final int userRatingCount;
  final String vicinity;
  final Geometry geometry;
  final BitmapDescriptor icon;

  Place(this.geometry, this.name, this.open, /*this.userRatingCount,*/ this.vicinity, this.icon);

  Place.fromJson(Map<dynamic, dynamic> parsedJson, BitmapDescriptor icon)
    : name = parsedJson['name'],
      //rating = (parsedJson['rating'] !=null) ? parsedJson['rating'].toDouble() : null,
      //userRatingCount = (parsedJson['user_ratings_total'] != null) ? parsedJson['user_ratings_total'] : null,
      open = (parsedJson.containsKey('opening_hours')) ? parsedJson['opening_hours']['open_now'] : false,
      vicinity = parsedJson['vicinity'],
      geometry = Geometry.fromJson(parsedJson['geometry']),
      icon=icon;
}