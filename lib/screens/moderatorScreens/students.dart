import 'package:appointment_scheduler/screens/moderatorScreens/stuInfo.dart';
import 'package:appointment_scheduler/widgets/appointmentList/circlePic.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//show disabled students list
class Students extends StatefulWidget {
  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final _auth = FirebaseAuth.instance;

  Future getInfo(id) async {
    late DocumentSnapshot docu;
    final User? user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) {
      docu = value;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentInfooo(
                docu['user_name'],
                docu['email'],
                docu['dept'],
                docu['session'],
                docu['reg'],
                docu['phone'],
                docu['image'])));
  }

  @override
  Widget build(BuildContext context) {
    //getUrl();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('students').snapshots(),
          builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                final User user = _auth.currentUser!;

                DocumentSnapshot document = snapshot.data!.docs[index];

                if (document['authentication status'] == "disabled") {
                  return GestureDetector(
                    onTap: () {
                      getInfo(document.id);
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: Text("Enable Account"),
                              content: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  Text('Do you want to enable this account?'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'NO',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('students')
                                              .doc(document.id)
                                              .update({
                                            'authentication status': "enabled"
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'YES',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))));
                      print(document.id);
                    },
                    child: Container(
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            elevation: 1,
                            color: Colors.deepPurple[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: 90,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    //width: 120,
                                    child: AcceptListBox(document['image']),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 280,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 30, left: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                document['user_name'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  );
                }
                return Text(
                  'hi',
                  style: TextStyle(color: Colors.white, fontSize: 0),
                );
              },
            );
          }),
    );
  }

// by calling this method the mofderator denies to verify the user and the user cant use his/her account
  Future deleteUser(String id) async {
    await FirebaseFirestore.instance.collection('students').doc(id).delete();
  }
}
