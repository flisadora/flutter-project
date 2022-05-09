import 'package:bytebank_persistence/screens/search.dart';
import 'package:bytebank_persistence/screens/expenses_list.dart';
import 'package:bytebank_persistence/screens/graphicsPage.dart';
import 'package:bytebank_persistence/services/geolocator_service.dart';
import 'package:bytebank_persistence/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bytebank_persistence/sensors/on_shake.dart';
import 'package:shake/shake.dart';

const _titleAppBar = 'WalletWatch';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late ShakeDetector detector;
    return Stack(
      children: <Widget>[
        OnShake(),
        Scaffold(
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text('Loading map...'),
                            behavior: SnackBarBehavior.floating
                          )
                        );
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
                  ],
                ),
              )
            ],
          ),
        ),
      ]
    );
  }

  void _ShowGraphic(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: "/GraphicsPage"),
        builder: (context) => GraphicsPage()),
    );
  }

  void _ShowExpensesList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: "/ExpensesList"),
        builder: (context) => ExpensesList()
      ),
    );
  }

  void _ShowShake(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: "/OnShake"),
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

    final location = await locatorService.getLocation();
    final places = await placesService.getPlaces(
      location.latitude,
      location.longitude,
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: "/Search"),
        builder: (context) => Search(location, places),
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