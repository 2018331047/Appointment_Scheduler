import 'package:flutter/material.dart';

class stuTopBar extends StatelessWidget {
  final String name;
  final String mail;
  final String dept;
  final String session;
  final String reg;
  final String phone;

  stuTopBar(
    this.name,
    this.mail,
    this.dept,
    this.session,
    this.reg,
    this.phone,
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
