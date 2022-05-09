import 'package:bytebank_persistence/models/place.dart';
import 'package:bytebank_persistence/services/geolocator_service.dart';
import 'package:bytebank_persistence/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

const _titleAppBar = 'ATM Locator';

class Search extends StatelessWidget {
  final Position? location;
  final List<Place> places;

  Search(this.location, this.places,);

  @override
  Widget build(BuildContext context) {

    final markerService = MarkerService();
    var markers = (places != null) ? markerService.getMarkers(places) : <Marker>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body:
      Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(location!.latitude,
                    location!.longitude),
                zoom: 15.0),
              zoomGesturesEnabled: true,
              markers: Set<Marker>.of(markers),
              myLocationEnabled: true,
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: (places.length > 0) ? ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(places[index].name),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 3.0),
                        Row(
                          children: <Widget>[
                            (places[index].open == 1) ?
                              Text(
                                'Open',
                                style: TextStyle(color: Colors.green),
                              )
                            :
                              Text(
                                'Closed',
                                style: TextStyle(color: Colors.red),
                              ),
                            Text(' \u00b7 ', style: TextStyle(fontWeight: FontWeight.bold)),
                            FutureBuilder<double>(
                              future: _getDistance(places[index].geometry.location.lat, places[index].geometry.location.lng),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  final double distance = snapshot.data as double;
                                  final int roudDistance = distance.round();
                                  return Text('$roudDistance meters');
                                }
                                return Text('');
                              }
                            ),
                          ]
                        ),
                        SizedBox(height: 5.0),
                        (places[index].vicinity != null)
                          ? Text(
                          '${places[index].vicinity}'
                          )
                          : Container(),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.directions),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _launchMapsUrl(
                          places[index].geometry.location.lat,
                          places[index].geometry.location.lng
                        );
                      },
                    ),
                  ),
                );
              }
            ) : Center(child:Text('No ATM Found Nearby')),
          )
        ],
      )
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<double> _getDistance(double placeLatitude, double placeLongitude) async {
    final geoService = GeoLocatorService();
    late double distance = 0;
    distance = await geoService.getDistance(
      location!.latitude, location!.longitude,
      placeLatitude, placeLongitude
    );
    return distance;
  }
}
