import 'package:appointment_scheduler/widgets/appointmentList/circlePic.dart';
import 'package:appointment_scheduler/widgets/createAPP2.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser!;
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .collection('addedTeacher')
            .orderBy('status')
            .snapshots(),
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];

                if (document['status'] == 'active') {
                  return GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) {
                          return CreateAppointment2(
                              id: document.id,
                              teacherName: document['name'],
                              picTea: document['image']);
                        },
                      );
                    },
                    child: Container(
                      width: size.width,
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(6),
                              child: Card(
                                elevation: 1,
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  height: 70,
                                  child: Row(
                                    children: [
                                      Stack(children: [
                                        Container(
                                          child:
                                              AcceptListBox(document['image']),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 52, left: 49),
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
                                      ]),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Container(
                                        child: Text(
                                          document['name'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                }

                return Container(
                    width: size.width,

                    // height: 100,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Card(
                            elevation: 1,
                            color: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Container(
                              height: 70,
                              child: Row(
                                children: [
                                  Container(
                                    //width: 120,
                                    child: AcceptListBox(document['image']),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Container(
                                    child: Text(
                                      document['name'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ));
              });
        });
  }
}
