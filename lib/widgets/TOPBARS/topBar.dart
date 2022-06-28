import 'package:appointment_scheduler/screens/student_screens/profile/editStudentProfile.dart';
import 'package:flutter/material.dart';

// used in student profile screen
class TopBar extends StatelessWidget {
  final String name;
  final String mail;
  final String dept;
  final String session;
  final String reg;
  final String phone;

  TopBar(
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
        IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditStudent()),
              );
            }),
      ],
    );
  }
}
