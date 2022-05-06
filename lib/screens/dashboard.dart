import 'package:bytebank_persistence/screens/atm_locator.dart';
import 'package:bytebank_persistence/screens/search.dart';
import 'package:bytebank_persistence/screens/expenses_list.dart';
import 'package:bytebank_persistence/screens/graphicsPage.dart';
import 'package:bytebank_persistence/screens/transactions_list.dart';
import 'package:bytebank_persistence/services/geolocator_service.dart';
import 'package:bytebank_persistence/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bytebank_persistence/sensors/on_shake.dart';

const _titleAppBar = 'WalletWatch';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
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
                  'Expenses',
                  Icons.money,
                  onClick: () {
                    _ShowExpensesList(context);
                  },
                ),
                _FeatureItem(
                  'ATM Locator',
                  Icons.map,
                  onClick: () {
                    _ShowSearch(context);
                  },
                ),
                _FeatureItem(
                  'Graphics',
                  Icons.graphic_eq,
                  onClick: () {
                    _ShowGraphic(context);
                  },
                ),
                _FeatureItem(
                  'Shake Sensor',
                  Icons.compare_arrows,
                  onClick: () {
                    _ShowShake(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _ShowGraphic(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GraphicsPage()),
    );
  }

  void _ShowExpensesList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ExpensesList()),
    );
  }

  void _ShowShake(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => OnShake()
      ),
    );
  }

  void _ShowSearch(BuildContext context) async {
    final locatorService = GeoLocatorService();
    final placesService = PlacesService();

    final locationPermission = await Geolocator.checkPermission();

    if (locationPermission != LocationPermission.always && locationPermission != LocationPermission.whileInUse) {
      await Geolocator.requestPermission();
    }

    print('cade????? 1');
    final location = await locatorService.getLocation();
    print('cade????? 2');
    final places = await placesService.getPlaces(location.latitude, location.longitude, BitmapDescriptor.defaultMarker,);
    print(places.toList().toString());
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Search(location, places),
      ),
    );

    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>?>(
              update: (context, position, icon, places){
                return
                  (position != null) ?
                  placesService.getPlaces(position.latitude, position.longitude, icon)
                      : null;
              },
            )
          ],
          child: Search(location, places,)
        ),
      ),
    );*/
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