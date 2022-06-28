import 'package:appointment_scheduler/screens/initScreens/signIn.dart';
import 'package:appointment_scheduler/screens/student_screens/OTHERS/resetPass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class settings extends StatelessWidget {
  Widget buildList(String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        size: 19,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {},
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
      ),
    );
  }

  final _auth = FirebaseAuth.instance;
  //String status = "Teacher";
  List<String> studentUids = [];
  Future<void> getType(id, context) async {
    late DocumentSnapshot docu;

    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(id)
        .get()
        .then((value) async {
      docu = value;
      if (docu.exists) {
        // status = "student";
        await getStudentList(FirebaseAuth.instance.currentUser!.uid);
        await changeActiveStatus(FirebaseAuth.instance.currentUser!.uid, false);
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false);
      } else {
        //status = "teacher";
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                size: 19,
              ),
              title: Text(
                'Change Password',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (_) {
                    return ResetPass();
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.palette,
                size: 19,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {},
              trailing: Switch(value: false, onChanged: null),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 19,
              ),
              title: Text(
                'LogOut',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () async {
                final User user = _auth.currentUser!;
                getType(user.uid, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future changeActiveStatus(String id, bool value) async {
    studentUids.forEach((element) async {
      (value)
          ? await FirebaseFirestore.instance
              .collection('students')
              .doc(element)
              .collection('addedTeacher')
              .doc(id)
              .update({'status': "active"})
          : await FirebaseFirestore.instance
              .collection('students')
              .doc(element)
              .collection('addedTeacher')
              .doc(id)
              .update({'status': "inactive"});
    });
  }

  Future getStudentList(String id) async {
    await FirebaseFirestore.instance.collection('teachers').doc(id).get().then(
        (value) => value['addedStudent']
            .forEach((element) => studentUids.add(element)));
  }

  // Future changeActiveStatus(String id, bool value) async {
  //   (value)
  //       ? await FirebaseFirestore.instance
  //           .collection('teachers')
  //           .doc(id)
  //           .update({'status': "active"})
  //       : await FirebaseFirestore.instance
  //           .collection('teachers')
  //           .doc(id)
  //           .update({'status': "inactive"});
  // }
}
