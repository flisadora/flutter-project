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
        //ScaffoldMessenger.of(context)
            //.showSnackBar(SnackBar(content: Text('Shake detector!')));
        Navigator.popUntil(
          context,
          (route) => route.isFirst);
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