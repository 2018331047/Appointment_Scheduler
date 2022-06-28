import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

class ShowQR extends StatelessWidget {
  GlobalKey globalKey = new GlobalKey();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(90.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            BarcodeWidget(
              barcode: Barcode.aztec(), // Barcode type and settings
              data: user.uid, // Content
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Share")),
          ],
        ),
      ),
    );
  }
}
