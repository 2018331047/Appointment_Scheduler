import 'package:appointment_scheduler/screens/teacherScreens/home_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditTeacher extends StatefulWidget {
  const EditTeacher({Key? key}) : super(key: key);

  @override
  _EditTeacherState createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  final _auth = FirebaseAuth.instance;
  final fullNameEditingController = new TextEditingController();
  final desiEditingController = new TextEditingController();
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
              //updating techer profile
              final User? user = _auth.currentUser;
              await FirebaseFirestore.instance
                  .collection('teachers')
                  .doc(user!.uid)
                  .update({
                // 'user_name': fullNameEditingController.text,
                'email': emailEditingController.text,
                'phone': phoneEditingController.text,
                'designation': desiEditingController.text,
              });

              //updating teachers info in appointment collection
              // var collection =
              //     FirebaseFirestore.instance.collection('appointments');
              // var querySnapshots = await collection.get();
              // for (var doc in querySnapshots.docs) {
              //   if (doc['other id'] == user.uid)
              //     await doc.reference.update({
              //       'teacherName': fullNameEditingController.text,
              //     });
              // }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
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
                      controller: desiEditingController,
                      keyboardType: TextInputType.name,
                      onSubmitted: (value) {
                        desiEditingController.text = value;
                        print(desiEditingController.text);
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                        hintText: "Designation",
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
