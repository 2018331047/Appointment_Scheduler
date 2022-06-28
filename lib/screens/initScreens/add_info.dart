import 'package:appointment_scheduler/database_service.dart/add_student.dart';
import 'package:appointment_scheduler/screens/initScreens/signIn.dart';
import 'package:appointment_scheduler/screens/student_screens/TABS/tabsScreen.dart';

import 'package:appointment_scheduler/widgets/loginButton/deco.dart';
import 'package:appointment_scheduler/widgets/loginScreenTitle/titleFour.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// collects student's information while signing up
class AddInfo extends StatelessWidget {
  final String name;
  final String email;
  //gets these infos from signup page
  AddInfo(this.name, this.email);

  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("CSE"), value: "CSE"),
      DropdownMenuItem(child: Text("EEE"), value: "EEE"),
      DropdownMenuItem(child: Text("FET"), value: "FET"),
      DropdownMenuItem(child: Text("CEP"), value: "CEP"),
      DropdownMenuItem(child: Text("IPE"), value: "IPE"),
      DropdownMenuItem(child: Text("PME"), value: "PME"),
      DropdownMenuItem(child: Text("ME"), value: "ME"),
      DropdownMenuItem(child: Text("CEE"), value: "CEE"),
      DropdownMenuItem(child: Text("Architecture"), value: "Architecture"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItems2 {
    List<DropdownMenuItem<String>> menuItems2 = [
      DropdownMenuItem(child: Text("Lecturer"), value: "Lecturer"),
      DropdownMenuItem(
          child: Text("Assistant Professor"), value: "Assistant Professor"),
      DropdownMenuItem(
          child: Text("Associate Professor"), value: "Associate Professor"),
      DropdownMenuItem(child: Text("Professor"), value: "Professor"),
    ];
    return menuItems2;
  }

  final TextEditingController deptController = new TextEditingController();
  final TextEditingController sessionController = new TextEditingController();
  final TextEditingController regController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title4('Update Profile'),
              SizedBox(
                height: size.height * 0.03,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(right: 20, top: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: deptController,
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          deptController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.school),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Department",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        controller: sessionController,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          sessionController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_view_day),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Session",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        controller: regController,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          regController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.app_registration),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Registration Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          phoneController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.app_registration),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 30),
                        child: MaterialButton(
                          textColor: Colors.white,
                          onPressed: () async {
                            Fluttertoast.showToast(msg: "Sign Up Successful");

                            postDetailsToFirestore(
                                deptController.text,
                                sessionController.text,
                                regController.text,
                                phoneController.text,
                                context);
                          },
                          padding: const EdgeInsets.all(0),
                          child: Deco('SAVE'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// sends these infos to addUser method which adds the infos of students to database
  postDetailsToFirestore(
      String dept, String session, String reg, String phone, context) async {
    String er = 'Account is not enabled';
    await AddUser(name, dept, session, reg, email, phone).addUser();
    final _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    late DocumentSnapshot docu;
    await FirebaseFirestore.instance
        .collection('students')
        .doc(user!.uid)
        .get()
        .then((value) async {
      docu = value;
      //after signing up if the student hasnt been verified yet he?she cant use the app still.
      //he/she will return to the login screen
      if (docu['authentication status'] == "disabled") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TabsScreen()));
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
        Fluttertoast.showToast(msg: er);
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TabsScreen()));
      }
    });
  }
}
