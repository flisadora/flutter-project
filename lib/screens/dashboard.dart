import 'package:bytebank_persistence/models/place.dart';
import 'package:bytebank_persistence/screens/atm_locator.dart';
import 'package:bytebank_persistence/screens/contacts_list.dart';
import 'package:bytebank_persistence/screens/search.dart';
import 'package:bytebank_persistence/screens/transactions_list.dart';
import 'package:bytebank_persistence/services/geolocator_service.dart';
import 'package:bytebank_persistence/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const _titleAppBar = 'Dashboard';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      /*body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(4, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
      ),*/
      /*body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/ww_logo.png'),
          ),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _FeatureItem(
                  'Transfer',
                  Icons.monetization_on,
                  onClick: () {
                    _ShowContactsList(context);
                  },
                ),
                _FeatureItem(
                  'Transaction Feed',
                  Icons.description,
                  onClick: () {
                    _ShowTransactionsList(context);
                  },
                ),
                _FeatureItem(
                  'Transaction Feed',
                  Icons.star,
                  onClick: () {
                    debugPrint('shine on');
                  },
                ),
              ],
            ),
          )
        ],
      ),*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/ww_logo.png'),
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _FeatureItem(
                  'Transfer',
                  Icons.monetization_on,
                  onClick: () {
                    _ShowContactsList(context);
                  },
                ),
                _FeatureItem(
                  'Transaction Feed',
                  Icons.description,
                  onClick: () {
                    _ShowTransactionsList(context);
                  },
                ),
                _FeatureItem(
                  'ATM Locator',
                  Icons.star,
                  onClick: () {
                    _ShowAtmLocator(context);
                  },
                ),
                _FeatureItem(
                  'ATM Locator new version',
                  Icons.search,
                  onClick: () {
                    _ShowSearch(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _ShowContactsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ContactsList()
      ),
    );
  }

  void _ShowTransactionsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => TransactionsList()
      ),
    );
  }

  void _ShowAtmLocator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AtmLocator()
      ),
    );
  }

  void _ShowSearch(BuildContext context) {
    final locatorService = GeoLocatorService();
    final placesService = PlacesService();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            FutureProvider<Position?>(
              initialData: null,
              create: (context) => locatorService.getLocation(),
            ),
            FutureProvider(create: (context) {
              ImageConfiguration configuration = createLocalImageConfiguration(context);
              return BitmapDescriptor.fromAssetImage(configuration, 'images/atm-marker.png');
            }, initialData: null,),
            ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>?>(
              update: (context, position, icon, places){
                return
                  (position != null) ?
                  placesService.getPlaces(position.latitude, position.longitude, icon)
                      : null;
              },
            )
          ],
          child: Search()
        ),
      ),
    );
  }

}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20.0,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
