import 'package:appointment_scheduler/utils/service/notification_service.dart';
import 'package:appointment_scheduler/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'appointment_description.dart';

/// class to render filterd appointments
class FilteredAppointments extends StatefulWidget {
  // index of bottomNavigationBar
  int index;
  // name of the course we want to filter
  String courseName;
  FilteredAppointments(
      {Key? key, required this.index, required this.courseName})
      : super(key: key);

  @override
  State<FilteredAppointments> createState() => _InstantAppointmentsState();
}

class _InstantAppointmentsState extends State<FilteredAppointments> {
  final _auth = FirebaseAuth.instance;

  late Map<String, dynamic> studentInfo;
  Future rejectAppointment(String id) async {
    await FirebaseFirestore.instance
        .collection('appointments')
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
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.courseName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.blue[100],
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .orderBy('date')
                .snapshots(),
            builder: (context, snapshot) {
              final User user = _auth.currentUser!;

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<DocumentSnapshot> requestedAppointments = snapshot
                    .data!.docs
                    .where((element) =>
                        element['status'] == "requested" &&
                        element['other id'] == user.uid &&
                        element['course title'] == widget.courseName &&
                        DateFormat('MM/dd/yyyy HH:mm a')
                            .parse("${element['date']} ${element['time']}")
                            .isAfter(DateTime.now()))
                    .toList();
                List<DocumentSnapshot> acceptedAppointments = snapshot
                    .data!.docs
                    .where((element) =>
                        element['status'] == "accepted" &&
                        element['other id'] == user.uid &&
                        element['course title'] == widget.courseName &&
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
                                  courseName:
                                      requestedAppointment['course title'],
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
                                          courseName: requestedAppointment[
                                              'course title'],
                                          isInstant: true,
                                          accepted: false,
                                          appointmentID:
                                              requestedAppointment.id,
                                          name: requestedAppointment[
                                              'student name'],
                                          title: requestedAppointment['title'],
                                          image: requestedAppointment[
                                              'student image'],
                                          date: DateFormat.MMMEd().format(date),
                                          dept: studentInfo['dept'],
                                          description: requestedAppointment[
                                              'description'],
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
                                  courseName:
                                      acceptedAppointment['course title'],
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
                                          courseName: acceptedAppointment[
                                              'course title'],
                                          isInstant: true,
                                          accepted: true,
                                          appointmentID: acceptedAppointment.id,
                                          name: acceptedAppointment[
                                              'student name'],
                                          title: acceptedAppointment['title'],
                                          image: acceptedAppointment[
                                              'student image'],
                                          date: DateFormat.MMMEd().format(date),
                                          dept: studentInfo['dept'],
                                          description: acceptedAppointment[
                                              'description'],
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
        ),
      ),
    );
  }
}
