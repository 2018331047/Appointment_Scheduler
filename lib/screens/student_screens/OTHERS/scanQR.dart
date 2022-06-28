import 'package:appointment_scheduler/database_service.dart/nestedCollection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getName(id) async {
    late DocumentSnapshot docu;
    String ID = id;
  }

  //function to scan barcode
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    _scanBarcode = barcodeScanRes;

//creatinf the addedTeacher collection
    late DocumentSnapshot docu;
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(barcodeScanRes)
        .get()
        .then((value) async {
      docu = value;
      Nested(barcodeScanRes, docu['user_name'], docu['status'], docu['image'])
          .addTeacher();
    });
    Fluttertoast.showToast(msg: 'Teacher Added');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return Container(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => scanBarcodeNormal(), child: Text('Scan Code')),
          ],
        ),
      );
    }));
  }
}
