import 'package:flutter/material.dart';

import 'screens/graphicsPage.dart';
import 'screens/dashboard.dart';
import 'screens/fingerprint_page.dart';

void main() {
  runApp(const WalletWatchApp());
}

class WalletWatchApp extends StatelessWidget {
  const WalletWatchApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green[900],
          secondary: Colors.blueAccent[700],
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
