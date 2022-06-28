import 'package:flutter/material.dart';

class Title1 extends StatelessWidget {
  final String title;

  Title1(
    this.title,
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: 28),
      width: size.width / 1.2,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
