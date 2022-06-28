import 'package:flutter/material.dart';

class GetTitle extends StatelessWidget {
  final String title;
  GetTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14, top: 30),
      child: Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
