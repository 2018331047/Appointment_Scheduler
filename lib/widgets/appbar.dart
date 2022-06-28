import 'package:flutter/material.dart';

class APPBAR extends StatelessWidget {
  final int index;
  APPBAR(this.index);
  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Text(
        'Scheduled',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      );
    }
    ;
    if (index == 1) {
      return Text(
        'Requested',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      );
    } else {
      return Text(
        'People',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      );
    }
  }
}
