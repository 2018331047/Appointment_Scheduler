import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  final int index;
  Appbar(this.index);
  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Text(
        ' Teachers',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      );
    } else {
      return Text(
        ' Students',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      );
    }
  }
}
