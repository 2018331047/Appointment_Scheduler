import 'package:appointment_scheduler/widgets/moderator/topbars/stuTopbar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appointment_scheduler/widgets/ProfileCard.dart';

// shows students profile info
class StudentInfooo extends StatefulWidget {
  final String name;
  final String dept;
  final String session;
  final String reg;
  final String email;
  final String phone;
  final String pic;

//gets these information from students file
  StudentInfooo(
    this.name,
    this.email,
    this.dept,
    this.session,
    this.reg,
    this.phone,
    this.pic,
  );

  @override
  State<StudentInfooo> createState() => _StudentInfoooState();
}

class _StudentInfoooState extends State<StudentInfooo> {
  final _auth = FirebaseAuth.instance;

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
                    child: stuTopBar(widget.name, widget.email, widget.dept,
                        widget.session, widget.reg, widget.phone),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            Container(
              child: Column(
                children: [
                  BuildCard('Full Name', Icons.person, widget.name),
                  BuildCard('Department', Icons.school, widget.dept),
                  BuildCard('Session', Icons.calendar_view_day, widget.session),
                  BuildCard('Registration', Icons.circle, widget.reg),
                  BuildCard('Email Address', Icons.call, widget.email),
                  BuildCard('Phone Number', Icons.call, widget.phone),
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
    path.lineTo(0, size.height - 90);

    var controllPoint = Offset(0, size.height - 0);
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
