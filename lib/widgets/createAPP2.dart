import 'package:appointment_scheduler/database_service.dart/addInstantAppointment.dart';

import 'package:appointment_scheduler/utils/service/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// creates instant appointment
class CreateAppointment2 extends StatefulWidget {
  final String id;
  final String teacherName;
  final String picTea;
  const CreateAppointment2(
      {Key? key,
      required this.id,
      required this.teacherName,
      required this.picTea})
      : super(key: key);

  @override
  _CreateAppointment2State createState() => _CreateAppointment2State();
}

class _CreateAppointment2State extends State<CreateAppointment2> {
  String err = "Appointment request sent";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String teacher;
  final titleEditingController = new TextEditingController();
  final courseEditingController = new TextEditingController();

  TextEditingController desinput = TextEditingController();

  void initState() {
    super.initState();
  }

  late String UserName;
  late String dept;
  late String reg;
  late String session;
  late String email;
  late String picStu;

  Future _getLocation() async {
    Position position = await Locator.determinePosition();
    String date = DateFormat.yMd().format(DateTime.now());
    print(date);
    String time = DateFormat('hh:mm a').format(DateTime.now());
    print(time);
    double lat = position.latitude;
    double long = position.longitude;
    final User user = _auth.currentUser!;
    late DocumentSnapshot document;
    await FirebaseFirestore.instance
        .collection('students')
        .doc(user.uid)
        .get()
        .then((value) {
      document = value;
    });
    UserName = document['user_name'];
    dept = document['dept'];
    reg = document['reg'];
    session = document['session'];
    email = document['email'];
    picStu = document['image'];

    AddInstantAppointment(
            widget.id,
            titleEditingController.text,
            date,
            "requested",
            widget.teacherName,
            UserName,
            lat,
            long,
            time,
            desinput.text,
            courseEditingController.text.toUpperCase(),
            picStu,
            widget.picTea)
        .addInstantAppointment();
    Fluttertoast.showToast(msg: err);
  }

  @override
  Widget build(BuildContext context) {
    //late TextEditingController c;
    return AlertDialog(
      title: Text("Create Appointment"),
      content: SingleChildScrollView(
        //child: Expanded(
        child: ListBody(
          children: [
            TextField(
              controller: courseEditingController,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(12),
              ],
              decoration: InputDecoration(
                hintText: 'Course Title',
              ),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (value) {
                courseEditingController.text = value;
              },
            ),
            TextField(
              controller: titleEditingController,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(12),
              ],
              decoration: InputDecoration(
                hintText: 'Title',
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                titleEditingController.text = value;
              },
            ),
            TextField(
              controller: desinput,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                desinput.text = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            _getLocation();
            Navigator.pop(context);
          },
          child: Text('CREATE'),
        ),
      ],
    );
  }
}
