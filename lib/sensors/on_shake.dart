import 'package:bytebank_persistence/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

class OnShake extends StatefulWidget {
  @override
  _OnShakeState createState() => _OnShakeState();
}

class _OnShakeState extends State<OnShake> {
  @override
  void initState() {
    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shake detector!')));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
        // Do stuff on phone shake
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

    // To close: detector.stopListening();
    // ShakeDetector.waitForStart() waits for user to call detector.startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}