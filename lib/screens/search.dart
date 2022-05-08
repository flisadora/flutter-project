import 'package:bytebank_persistence/models/place.dart';
import 'package:bytebank_persistence/services/geolocator_service.dart';
import 'package:bytebank_persistence/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _titleAppBar = 'ATM Locator';

class Search extends StatelessWidget {
  final Position? location;
  final List<Place> places;

  Search(this.location, this.places,);

  @override
  Widget build(BuildContext context) {

    final geoService = GeoLocatorService();
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
                return FutureProvider(
                  create: (context) =>
                    geoService.getDistance(
                      location!.latitude,
                      location!.longitude,
                      places[index]
                        .geometry
                        .location
                        .lat,
                      places[index]
                        .geometry
                        .location
                        .lng
                    ),
                    initialData: null,
                    child: Card(
                      child: ListTile(
                        title: Text(places[index].name),
                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 3.0),
                            (places[index].open != null) ? Row(
                              children: <Widget>[
                                (places[index].open == 1) ?
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    'Open',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                )
                                :
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    'Closed',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            ) : Row(),
                            SizedBox(height: 5.0),
                            Consumer<double>(
                              builder:
                                (context, meters, wiget) {
                                  return (meters != null)
                                  ? Text(
                                  '${places[index].vicinity} \u00b7 ${(meters / 1609).round()} mi')
                                  : Container();
                              },
                            )
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
                    ),
                  );
                }
                ) : Center(child:Text('No ATM Found Nearby')),
              )
            ],
          )
        //},
        );
      //);


    /*
    return FutureProvider(
      create: (context) => placesProvider,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleAppBar),
        ),
        body: (location != null)
            ? Consumer<List<Place>>(
          builder: (_, places, __) {
            var markers = (places != null) ? markerService.getMarkers(places) : <Marker>[];
              return (places != null) ? Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(location!.latitude,
                              location!.longitude),
                          zoom: 16.0),
                      zoomGesturesEnabled: true,
                      markers: Set<Marker>.of(markers),
                    ),
                  ),
                  SizedBox(height: 10.0),
                Expanded(
                  child: (places.length > 0) ? ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return FutureProvider(
                        create: (context) =>
                            geoService.getDistance(
                                location!.latitude,
                                location!.longitude,
                                places[index]
                                    .geometry
                                    .location
                                    .lat,
                                places[index]
                                    .geometry
                                    .location
                                    .lng),
                        initialData: null,
                        child: Card(
                          child: ListTile(
                            title: Text(places[index].name),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 3.0),
                                (places[index].rating != null) ? Row(
                                  children: <Widget>[
                                    RatingBarIndicator(
                                      rating: places[index].rating,
                                      itemBuilder: (context,
                                        index) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber
                                        ),
                                        itemCount: 5,
                                        itemSize: 10.0,
                                        direction:
                                        Axis.horizontal,
                                      )
                                    ],
                                  ) : Row(),
                                  SizedBox(height: 5.0),
                                  Consumer<double>(
                                    builder:
                                      (context, meters, wiget) {
                                        return (meters != null)
                                          ? Text(
                                          '${places[index].vicinity} \u00b7 ${(meters / 1609).round()} mi')
                                          : Container();
                                      },
                                  )
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
                          ),
                        );
                      }) : Center(child:Text('No Parking Found Nearby'),),
                )
              ],
            )
                : Center(child: CircularProgressIndicator());
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );*/
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
