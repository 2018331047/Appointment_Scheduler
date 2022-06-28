import 'package:appointment_scheduler/screens/student_screens/profile/stuImage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appointment_scheduler/widgets/ProfileCard.dart';
import 'package:appointment_scheduler/widgets/TOPBARS/topBar.dart';

class UserProfile extends StatefulWidget {
  final String name;
  final String dept;
  final String session;
  final String reg;
  final String email;
  final String phone;

  UserProfile(
    this.name,
    this.email,
    this.dept,
    this.session,
    this.reg,
    this.phone,
  );

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
              height: size.height / 3,
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
                  UserImage(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 75, left: 40),
                      child: Column(
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.email,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: TopBar(widget.name, widget.email, widget.dept,
                        widget.session, widget.reg, widget.phone),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              //color: Colors.grey[200],
              child: Column(
                children: [
                  BuildCard('Full Name', Icons.person, widget.name),
                  BuildCard('Department', Icons.school, widget.dept),
                  BuildCard('Session', Icons.calendar_view_day, widget.session),
                  BuildCard('Registration', Icons.circle, widget.reg),
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

//upper part decoration
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 90);

    var controllPoint = Offset(0, size.height - 60);
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
