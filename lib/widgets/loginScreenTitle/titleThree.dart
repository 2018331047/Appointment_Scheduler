import 'package:flutter/material.dart';

class Title3 extends StatelessWidget {
  final String title;

  Title3(
    this.title,
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 1.2,
      padding: EdgeInsets.only(left: 28),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 15,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
