import 'package:appointment_scheduler/database_service.dart/add_teacher.dart';
import 'package:appointment_scheduler/screens/initScreens/signIn.dart';

import 'package:appointment_scheduler/screens/teacherScreens/home_screen.dart';

import 'package:appointment_scheduler/widgets/loginButton/deco.dart';
import 'package:appointment_scheduler/widgets/loginScreenTitle/titleFour.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//collects teacher info while signing up
class TeacherInfo extends StatefulWidget {
  final String name;
  final String email;
  TeacherInfo(this.name, this.email);

  @override
  State<TeacherInfo> createState() => _TeacherInfoState();
}

class _TeacherInfoState extends State<TeacherInfo> {
  final _dropdownFormKey = GlobalKey<FormState>();

  final TextEditingController phoneController = new TextEditingController();

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

  String? selectedDept;
  String? selectedDesignation;

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
                key: _dropdownFormKey,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(right: 20, top: 20),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            //icon: Icon(Icons.school),
                            hintText: 'Department',
                            prefixIcon: Icon(Icons.school),
                            //icon: Icon(Icons.school),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) =>
                              value == null ? "Select Department" : null,
                          dropdownColor: Colors.grey[200],
                          value: selectedDept,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDept = newValue!;
                            });
                          },
                          items: dropdownItems),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Designation',
                            prefixIcon: Icon(Icons.work_outline),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) =>
                              value == null ? "Select Designation" : null,
                          dropdownColor: Colors.grey[200],
                          value: selectedDesignation,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDesignation = newValue!;
                            });
                          },
                          items: dropdownItems2),
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
                                selectedDept!,
                                selectedDesignation!,
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

//getting all the teachers info and sending it to the addUser2 method which adds teachers in teachers collection in firebase
  postDetailsToFirestore(
      String dept, String designation, String phone, context) async {
    await AddUser2(widget.name, widget.email, dept, designation, phone)
        .addUser2();
    String er = 'Account is not enabled';

    final _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    late DocumentSnapshot docu;
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(user!.uid)
        .get()
        .then((value) async {
      docu = value;
      //checking if the the user id verified by moderator or not and then navigating accorting to that
      if (docu['authentication status'] == "disabled") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
        Fluttertoast.showToast(msg: er);
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }
}
