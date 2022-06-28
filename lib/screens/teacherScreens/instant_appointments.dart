import 'package:appointment_scheduler/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'appointment_description.dart';

///class for rendering instant appointments
class InstantAppointments extends StatefulWidget {
  // this is the index value of bottomNavigationBar
  int index;
  InstantAppointments({Key? key, required this.index}) : super(key: key);

  @override
  State<InstantAppointments> createState() => _InstantAppointmentsState();
}

class _InstantAppointmentsState extends State<InstantAppointments> {
  final _auth = FirebaseAuth.instance;

  late Map<String, dynamic> studentInfo;
  Future rejectAppointment(String id) async {
    await FirebaseFirestore.instance
        .collection('instant appointments')
        .doc(id)
        .delete();
  }

  Future getStudentData(String id) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) => studentInfo = value.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.green[100],
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('instant appointments')
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          final User user = _auth.currentUser!;

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<DocumentSnapshot> requestedAppointments = snapshot.data!.docs
                .where((element) =>
                    element['status'] == "requested" &&
                    element['other id'] == user.uid &&
                    DateFormat('MM/dd/yyyy HH:mm a')
                        .parse("${element['date']} ${element['time']}")
                        .isAfter(DateTime.now()))
                .toList();
            List<DocumentSnapshot> acceptedAppointments = snapshot.data!.docs
                .where((element) =>
                    element['status'] == "accepted" &&
                    element['other id'] == user.uid &&
                    DateFormat('MM/dd/yyyy HH:mm a')
                        .parse("${element['date']} ${element['time']}")
                        .isAfter(DateTime.now()))
                .toList();

            return (widget.index == 0)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: requestedAppointments.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot requestedAppointment =
                          requestedAppointments[index];
                      DateTime date = DateFormat('MM/dd/yyyy HH:mm a').parse(
                          "${requestedAppointment['date']} ${requestedAppointment['time']}");
                      return (requestedAppointments.isEmpty)
                          ? Center(
                              child: Text("No appointments"),
                            )
                          : AppointmentCard(
                              courseName: requestedAppointment['course title'],
                              isInstant: true,
                              id: requestedAppointment.id,
                              isRequested: true,
                              name: requestedAppointment['student name'],
                              date: DateFormat.MMMEd().format(date),
                              time: requestedAppointment['time'],
                              title: requestedAppointment['title'],
                              image: requestedAppointment['student image'],
                              navigation: () async {
                                await getStudentData(
                                    requestedAppointment['student id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentDescription(
                                      courseName:
                                          requestedAppointment['course title'],
                                      isInstant: true,
                                      accepted: false,
                                      appointmentID: requestedAppointment.id,
                                      name:
                                          requestedAppointment['student name'],
                                      title: requestedAppointment['title'],
                                      image:
                                          requestedAppointment['student image'],
                                      date: DateFormat.MMMEd().format(date),
                                      dept: studentInfo['dept'],
                                      description:
                                          requestedAppointment['description'],
                                      lat: requestedAppointment['lat'],
                                      long: requestedAppointment['long'],
                                      regNo: studentInfo['reg'],
                                      time: requestedAppointment['time'],
                                      phone: studentInfo['phone'],
                                    ),
                                  ),
                                );
                              },
                            );
                    })
                : ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: acceptedAppointments.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot acceptedAppointment =
                          acceptedAppointments[index];
                      DateTime date = DateFormat('MM/dd/yyyy HH:mm a').parse(
                          "${acceptedAppointment['date']} ${acceptedAppointment['time']}");
                      return (acceptedAppointments.isEmpty)
                          ? Center(
                              child: Text("No appointments"),
                            )
                          : AppointmentCard(
                              courseName: acceptedAppointment['course title'],
                              isInstant: true,
                              id: acceptedAppointment.id,
                              name: acceptedAppointment['student name'],
                              date: DateFormat.MMMEd().format(date),
                              time: acceptedAppointment['time'],
                              title: acceptedAppointment['title'],
                              image: acceptedAppointment['student image'],
                              navigation: () async {
                                await getStudentData(
                                    acceptedAppointment['student id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentDescription(
                                      courseName:
                                          acceptedAppointment['course title'],
                                      isInstant: true,
                                      accepted: true,
                                      appointmentID: acceptedAppointment.id,
                                      name: acceptedAppointment['student name'],
                                      title: acceptedAppointment['title'],
                                      image:
                                          acceptedAppointment['student image'],
                                      date: DateFormat.MMMEd().format(date),
                                      dept: studentInfo['dept'],
                                      description:
                                          acceptedAppointment['description'],
                                      lat: acceptedAppointment['lat'],
                                      long: acceptedAppointment['long'],
                                      regNo: studentInfo['reg'],
                                      time: acceptedAppointment['time'],
                                      phone: studentInfo['phone'],
                                    ),
                                  ),
                                );
                              });
                    });
          }
        },
      ),
    );
  }
}
