import 'dart:math';

import 'package:appointment_scheduler/utils/service/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// class to render appointment's description
class AppointmentDescription extends StatelessWidget {
  //boolean to check whether the appointment is intant appointment type or not
  final bool? isInstant;
  final Image? img;
  final String time;
  final String date;
  final String name;
  final String regNo;
  final String dept;
  final String title;
  final String description;
  final double lat;
  final double long;
  final String appointmentID;
  final String phone;
  //boolean to check whether the appointment is accepted or not
  final bool accepted;
  final String image;
  final String courseName;

  const AppointmentDescription({
    Key? key,
    this.img,
    required this.accepted,
    required this.phone,
    required this.time,
    required this.date,
    required this.name,
    required this.regNo,
    required this.dept,
    required this.title,
    required this.description,
    required this.lat,
    required this.long,
    required this.appointmentID,
    required this.image,
    this.isInstant,
    required this.courseName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (accepted) ? Colors.green[400] : Colors.blue[400],
        centerTitle: true,
        title: const Text("Appointment Request",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFAB(
        id: appointmentID,
        flag: accepted,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              width: _width * 1.5,
              height: 300,
              decoration: BoxDecoration(
                  color: (accepted) ? Colors.green[400] : Colors.blue[400],
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(100))),
            ),
            //Profile Image
            Positioned(
              top: 220,
              left: 30,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey,
                  foregroundImage: NetworkImage(image),
                ),
              ),
            ),
            //phone call
            Positioned(
              top: 260,
              right: 80,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: GestureDetector(
                  onTap: () async {
                    launch('tel:$phone');
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        (accepted) ? Colors.blue[400] : Colors.green[400],
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 100, bottom: 30, left: 45, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Date
                  Text(
                    date,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Time
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 220,
                  ),
                  //Name
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Dept name
                  Text(
                    dept,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //Registration number
                  Row(
                    children: [
                      Text(
                        "Regi. No:",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        regNo,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Seeks yous attention on,",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Title
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // course tag
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.purple[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      courseName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// method to reject appointents
/// appointment's  uid[id], if appointment intant appointment type[isInstant]
Future rejectAppointment(String id, bool? isInstant) async {
  await FirebaseFirestore.instance.collection('appointments').doc(id).delete();
}

/// method to accept appointents
/// appointment's  uid[id], if appointment intant appointment type[isInstant]
Future acceptAppointment(String id, bool? isInstant) async {
  (isInstant != null)
      ? await FirebaseFirestore.instance
          .collection('instant appointments')
          .doc(id)
          .update({'status': "accepted"})
      : await FirebaseFirestore.instance
          .collection('appointments')
          .doc(id)
          .update({'status': "accepted"});

  if (isInstant == null) {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(id)
        .get()
        .then((value) {
      DateTime schedule = DateFormat('MM/dd/yyyy HH:mm a')
          .parse("${value['date']} ${value['time']}")
          .subtract(Duration(minutes: 10));
      debugPrint(schedule.toString());
      NotificationApi.showScheduledNotification(
        id: 0,
        body: "You have an appointment scheduled at ${value['time']}",
        payload: "",
        title: "${value['student name']} is seeking your attention",
        scheduledDate: schedule,
      );
    });
  }
}

/// custom floating action button
class CustomFAB extends StatelessWidget {
  // appointment's uid
  final String id;
  // flag to check if the appointment is accepted or not
  final bool flag;
  // bool to check if the appointment is instant type or not
  final bool? instantAp;
  const CustomFAB(
      {Key? key, required this.id, required this.flag, this.instantAp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (flag)
        ? Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.red,
            ),
            child: GestureDetector(
              onTap: () {
                rejectAppointment(id, instantAp);
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "Reject",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: () {
                    acceptAppointment(id, instantAp);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      "Accept",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                ),
                child: GestureDetector(
                  onTap: () {
                    rejectAppointment(id, instantAp);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      "Reject",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
