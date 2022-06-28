import 'package:appointment_scheduler/widgets/CALENDER/calender.dart';
import 'package:appointment_scheduler/widgets/mainDrawerUpper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appointment_scheduler/screens/student_screens/profile/stuProfile.dart';
import '../screens/student_screens/OTHERS/settings.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Widget buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
      ),
      title: Text(title),
      onTap: () {},
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
//getting the info of the user to show in drawer upper part
  Future<void> getName(id, context) async {
    late DocumentSnapshot docu;

    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) {
      docu = value;
    });

    print(docu['phone']);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfile(
          docu['user_name'] ?? '',
          docu['email'] ?? ' ',
          docu['dept'] ?? ' ',
          docu['session'] ?? ' ',
          docu['reg'] ?? ' ',
          docu['phone'] ?? ' ',
          //docu['image'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          children: [
            Upper(),
            SizedBox(
              height: 40,
            ),
            const Divider(
              height: 1,
              thickness: 2,
              indent: 5,
              endIndent: 10,
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                size: 20,
              ),
              title: Text('Profile'),
              onTap: () async {
                final User user = _auth.currentUser!;
                getName(user.uid, context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                size: 20,
              ),
              title: Text('Calender'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Calendar()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 20,
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => settings()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
