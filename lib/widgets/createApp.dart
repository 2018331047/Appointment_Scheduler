import 'package:appointment_scheduler/database_service.dart/add_appointment.dart';
import 'package:appointment_scheduler/utils/service/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

//to get an appointment schedule
class CreateAppointment extends StatefulWidget {
  @override
  _CreateAppointmentState createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  String err = "Appointment request sent";
  var selectedTeacher;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String teacher;
  final titleEditingController = new TextEditingController();
  final courseEditingController = new TextEditingController();
  late String teacherName;
  //late DateTime selectedDate;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController desinput = TextEditingController();

  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  late String name;
  late String picTea;
  Future<void> getName(id) async {
    //final User user = _auth.currentUser!;
    late DocumentSnapshot document;
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(id)
        .get()
        .then((value) {
      document = value;
    });
    name = document['user_name'];
    picTea = document['image'];
  }

  late String UserName;
  late String picStu;
  late String dept;
  late String reg;
  late String session;
  late String email;
  Future<void> GetName(id) async {
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
  }

  Future _getLocation() async {
    Position position = await Locator.determinePosition();
    double lat = position.latitude;
    double long = position.longitude;
    //print(selectedTeacher);
    //print(lat);
    //print(long);
    AddAppointment(
            selectedTeacher,
            titleEditingController.text,
            dateinput.text,
            "requested",
            name,
            UserName,
            lat,
            long,
            timeinput.text,
            desinput.text,
            courseEditingController.text.toUpperCase(),
            picStu,
            picTea)
        .addAppointment();
    Fluttertoast.showToast(msg: err);
    //locationNotifier.value = true;
  }

  @override
  Widget build(BuildContext context) {
    //late TextEditingController c;
    final User user = _auth.currentUser!;
    return AlertDialog(
      title: Text("Create Appointment"),
      content: SingleChildScrollView(
        //child: Expanded(
        child: ListBody(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("students")
                  .doc(user.uid)
                  .collection('addedTeacher')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Text("NO DATA"),
                  );
                else {
                  List<DropdownMenuItem> teacherItems = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    QueryDocumentSnapshot<Object?> snap =
                        snapshot.data!.docs[i];

                    teacherItems.add(
                      DropdownMenuItem(
                        child: Text(
                          snap['name'],
                          style: TextStyle(fontSize: 16),
                        ),
                        value: "${snap.id}",
                      ),
                    );
                  }
                  return Row(children: [
                    Expanded(
                      child: DropdownButton<dynamic>(
                        items: teacherItems,
                        onChanged: (teacherValue) {
                          setState(() {
                            selectedTeacher = teacherValue;
                          });
                          final User? user = _auth.currentUser!;
                          getName(selectedTeacher);
                          GetName(user!.uid);
                        },
                        value: selectedTeacher,

                        //isExpanded: false,
                        hint: Text(
                          "Teacher",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ]);
                }
              },
            ),
            TextField(
              controller: courseEditingController,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(12),
              ],
              decoration: InputDecoration(
                hintText: 'Course Title',
              ),
              textInputAction: TextInputAction.next,
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
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Date',
                ),
                controller: dateinput,
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2023),
                  ).then((pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    String formattedDate = DateFormat.yMd().format(pickedDate);
                    setState(() {
                      dateinput.text = formattedDate;
                      //print(dateinput.text);
                    });
                  });
                }),
            TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Time',
                ),
                controller: timeinput,
                onTap: () async {
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.input,
                  ).then((pickedTime) {
                    if (pickedTime == null) {
                      return;
                    }
                    // String formattedTime ;
                    setState(() {
                      timeinput.text = pickedTime.format(context);
                      //print(timeinput.text);
                    });
                  });
                }),
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
            // print(name);
            _getLocation();
            Navigator.pop(context);
          },
          child: Text('CREATE'),
        ),
      ],
    );
  }
}
