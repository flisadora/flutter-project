import 'package:bytebank_persistence/models/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place{
  final String name;
  final int open;
  final String vicinity;
  final Geometry geometry;
  final BitmapDescriptor icon;

  Place(this.geometry, this.name, this.open, this.vicinity, this.icon);

  Place.fromJson(Map<dynamic, dynamic> parsedJson, BitmapDescriptor icon)
    : name = parsedJson['name'],
      open = (parsedJson.containsKey('opening_hours')) ? ((parsedJson['opening_hours']['open_now']) ? 1 : 2) : 3,
      vicinity = parsedJson['vicinity'],
      geometry = Geometry.fromJson(parsedJson['geometry']),
      icon = icon;
}