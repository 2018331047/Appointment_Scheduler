import 'package:flutter/material.dart';

class teaTopBar2 extends StatelessWidget {
  final String name;
  final String mail;
  final String dept;
  final String designation;

  final String phone;
  teaTopBar2(this.name, this.mail, this.dept, this.designation, this.phone);
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
