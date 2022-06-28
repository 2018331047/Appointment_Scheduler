import 'package:appointment_scheduler/screens/initScreens/empty.dart';
import 'package:appointment_scheduler/screens/student_screens/TABS/tabsScreen.dart';
import 'package:appointment_scheduler/screens/teacherScreens/home_screen.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment_scheduler/screens/initScreens/signIn.dart';

// to keep track whether user is already logged in or not and where to navigate
enum AuthStatus {
  notLoggedIn,
  LoggedIn,
}

class homee extends StatefulWidget {
  @override
  State<homee> createState() => _homeeState();
}

class _homeeState extends State<homee> {
  AuthStatus status = AuthStatus.LoggedIn;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String stat = "student";

  @override
  void didChangeDependencies() async {
    //first we initialized the stat var as Student . then checked if the user exists. is exists then
    //checked the type of user. and according to the assigned value we changed the authstatus

    try {
      final User user = _auth.currentUser!;
      if (user != null) {
        late DocumentSnapshot docu;
        await FirebaseFirestore.instance
            .collection('teachers')
            .doc(user.uid)
            .get()
            .then((value) async {
          docu = value;
          if (docu.exists) {
            setState(() {
              stat = "teachers";
            });
          }
        });
        setState(() {
          status = AuthStatus.LoggedIn;
        });
      }
    } catch (e) {
      status = AuthStatus.notLoggedIn;
    }
  }

  @override
  Widget build(BuildContext context) {
    //first we initialized  the retVal widget with an empty screen  then according to the status we navigated the users
    // to their expected screen
    Widget retVal = Empty();
    if (status == AuthStatus.notLoggedIn) {
      retVal = SignIn();
    } else if (status == AuthStatus.LoggedIn) {
      if (stat == "teachers")
        retVal = HomeScreen();
      else
        retVal = TabsScreen();
    }

    return retVal;
  }
}
