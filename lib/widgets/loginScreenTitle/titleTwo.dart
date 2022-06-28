import 'package:flutter/material.dart';

class Title2 extends StatelessWidget {
  final String title1;
  final String title2;

  Title2(
    this.title1,
    this.title2,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 28),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: title1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: title2,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }
}
