import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String title;
  ButtonText(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
