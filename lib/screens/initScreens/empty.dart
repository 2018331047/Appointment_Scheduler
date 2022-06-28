import 'package:flutter/material.dart';

//used an empty screen to initiate the app before deciding if the user is logged in or not
class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'hi',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
