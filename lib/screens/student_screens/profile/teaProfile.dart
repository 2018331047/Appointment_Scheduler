import 'package:appointment_scheduler/screens/student_screens/profile/teaImage.dart';
import 'package:appointment_scheduler/widgets/TOPBARS/topbar2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appointment_scheduler/widgets/ProfileCard.dart';

class TeacherProfile extends StatefulWidget {
  final String name;
  final String email;
  final String dept;
  final String designation;
  final String phone;

  TeacherProfile(
    this.name,
    this.email,
    this.dept,
    this.designation,
    this.phone,
  );

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  final _auth = FirebaseAuth.instance;
  String url =
      "https://monomousumi.com/wp-content/uploads/anonymous-user-3.png";
  Future getUrl() async {
    late DocumentSnapshot docu;
    final User? user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(user!.uid)
        .get()
        .then((value) {
      docu = value;
    });
    if (mounted) {
      setState(() {
        url = docu['image'];
      });
    }
  }

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
                            Colors.lightBlueAccent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  TeacherImage(),
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
                    child: TopBar2(widget.name, widget.email, widget.dept,
                        widget.designation, widget.phone),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 10,
            ),
            Container(
              child: Column(
                children: [
                  BuildCard('Full Name', Icons.person, widget.name),
                  BuildCard('Department', Icons.school, widget.dept),
                  BuildCard('Designation', Icons.calendar_view_day,
                      widget.designation),
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

//upper part decoration
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
