import 'dart:convert';
import 'dart:io';

import 'package:bytebank_persistence/models/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const _titleAppBar = 'QR Code Scan';

class QrCodeScan extends StatefulWidget {
  const QrCodeScan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final Expense _expense;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleAppBar)),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Expense found!'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        //width: double.maxFinite,
                        child: ElevatedButton(
                          child: Text('Use expense scanned'),
                          onPressed: () {
                            _expense = _toExpense(result!.code.toString());
                            print('ON PRESSED: $_expense');
                            Navigator.pop(context, _expense);
                          },
                        ),
                      ),
                    ),
                    //Text('Format: ${result!.format}'),
                  ],
                )
                : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Expense _toExpense(String result) {
    final Map<String, dynamic> expenseMap = jsonDecode(result);
    final expense = new Expense(0,
        expenseMap['type'],
        double.tryParse(expenseMap['value']),
        expenseMap['label'],
        expenseMap['date']
    );
    return expense;
  }
}