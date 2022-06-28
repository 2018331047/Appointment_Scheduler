import 'package:appointment_scheduler/screens/student_screens/TABS/tabsScreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key}) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _auth = FirebaseAuth.instance;
  final fullNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final phoneEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.black,
            ),
            onPressed: () async {
              //updating student profile
              final User? user = _auth.currentUser;
              await FirebaseFirestore.instance
                  .collection('students')
                  .doc(user!.uid)
                  .update({
                //'user_name': fullNameEditingController.text,
                'email': emailEditingController.text,
                'phone': phoneEditingController.text,
              });

              // var collection =
              //     FirebaseFirestore.instance.collection('appointments');
              // var querySnapshots = await collection.get();
              // for (var doc in querySnapshots.docs) {
              //   if (doc['student id'] == user.uid)
              //     await doc.reference.update({
              //       'student name': fullNameEditingController.text,
              //     });
              // }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => TabsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(right: 20, top: 20),
                child: Column(
                  children: [
                    // TextField(
                    //   controller: fullNameEditingController,
                    //   keyboardType: TextInputType.name,
                    //   onSubmitted: (value) {
                    //     fullNameEditingController.text = value;
                    //     print(fullNameEditingController.text);
                    //   },
                    //   decoration: InputDecoration(
                    //     contentPadding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                    //     hintText: "Full Name",
                    //     hintStyle: TextStyle(fontSize: 18),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      onSubmitted: (value) {
                        emailEditingController.text = value;
                        print(emailEditingController.text);
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                        hintText: "Email",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: phoneEditingController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        phoneEditingController.text = value;
                        print(phoneEditingController.text);
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                        hintText: "Phone Number",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
