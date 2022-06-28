import 'package:appointment_scheduler/widgets/appointmentList/circlePic.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Requested extends StatefulWidget {
  @override
  State<Requested> createState() => _RequestedState();
}

class _RequestedState extends State<Requested> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .orderBy('date')
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
                final User user = _auth.currentUser!;

                DocumentSnapshot document = snapshot.data!.docs[index];
                String date = DateFormat.yMd().format(DateTime.now());
                DateTime dateTime = DateFormat.yMd().parse(date);
                DateTime dt = DateFormat.yMd().parse(document['date']);
                DateTime dtt = DateFormat.jm().parse(document['time']);

                String time = DateFormat.Hm().format(DateTime.now());

                DateTime dttt = DateFormat.Hm().parse(time);

                if ((document['status'] == "requested" &&
                        document['student id'] == user.uid &&
                        dt.difference(dateTime).inHours > 0) ||
                    (document['status'] == "requested" &&
                        document['student id'] == user.uid &&
                        dt.difference(dateTime).inHours == 0 &&
                        dtt.difference(dttt).inSeconds >= 0)) {
                  DateTime dateee = DateFormat('MM/dd/yyyy HH:mm a')
                      .parse("${document['date']} ${document['time']}");

                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: Text("DELETE APPOINTMENT"),
                              content: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  Text(
                                      'Are you sure you want to delete the appointment?'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          rejectAppointment(document.id);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'DELETE',
                                          style: TextStyle(fontSize: 16),
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                elevation: 1,
                                color: Colors.blue[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  height: 90,
                                  child: Row(
                                    children: [
                                      Container(
                                        //width: 120,
                                        child: AcceptListBox(
                                            document['teacher image']),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                        width: 280,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 17, left: 6, right: 10),
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
                                                    document['teacherName'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(height: 15),
                                                  Text(
                                                    document['title'],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.clip,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(height: 10),
                                                  Text(
                                                    DateFormat.MMMEd()
                                                        .format(dateee),
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.blue[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 7),
                                                  Text(
                                                    document['time'],
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.blue[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
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
                            ),
                          ],
                        )),
                  );
                }
                return SizedBox(
                  height: 0,
                );
              },
            );
          }),
    );
  }

  Future rejectAppointment(String id) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(id)
        .delete();
  }
}
