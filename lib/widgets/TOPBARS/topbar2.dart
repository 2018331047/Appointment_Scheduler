import 'package:appointment_scheduler/screens/student_screens/profile/editStudentProfile.dart';
import 'package:appointment_scheduler/screens/student_screens/profile/editTeacherProfile.dart';
import 'package:flutter/material.dart';

//used in teacher profile screen
class TopBar2 extends StatelessWidget {
  final String name;
  final String mail;
  final String dept;
  final String designation;

  final String phone;
  TopBar2(this.name, this.mail, this.dept, this.designation, this.phone);
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
                MaterialPageRoute(builder: (context) => EditTeacher()),
              );
            }),
      ],
    );
  }
}
