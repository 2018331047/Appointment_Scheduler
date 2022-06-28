import 'package:appointment_scheduler/widgets/moderator/topbars/teaTopbar.dart';

import 'package:flutter/material.dart';
import 'package:appointment_scheduler/widgets/ProfileCard.dart';

// shows tecahers profile info
class TeacherInfooo extends StatefulWidget {
  final String name;
  final String email;
  final String dept;
  final String designation;
  final String phone;
  final String pic;
  // gets these infos from teachers file
  TeacherInfooo(
    this.name,
    this.email,
    this.dept,
    this.designation,
    this.phone,
    this.pic,
  );

  @override
  State<TeacherInfooo> createState() => _TeacherInfoooState();
}

class _TeacherInfoooState extends State<TeacherInfooo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              height: size.height / 3.2,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.lightBlue,
                            Colors.lightBlueAccent,
                            Colors.lightBlueAccent,
                            Colors.lightBlueAccent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 110, right: 60),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: size.height / 2,
                        width: size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                              image: NetworkImage(widget.pic),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: teaTopBar2(widget.name, widget.email, widget.dept,
                        widget.designation, widget.phone),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              child: Column(
                children: [
                  BuildCard('Full Name', Icons.person, widget.name),
                  BuildCard('Department', Icons.school, widget.dept),
                  BuildCard('Designation', Icons.calendar_view_day,
                      widget.designation),
                  BuildCard('Email', Icons.email, widget.email),
                  BuildCard('Phone Number', Icons.circle, widget.phone),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 80);

    var controllPoint = Offset(0, size.height - 50);
    var endPoint = Offset(size.width / 6, size.height);
    path.quadraticBezierTo(
      controllPoint.dx,
      controllPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
