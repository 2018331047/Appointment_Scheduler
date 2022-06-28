import 'package:flutter/material.dart';

class Title4 extends StatelessWidget {
  final String title;

  Title4(
    this.title,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 28),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: title,
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
