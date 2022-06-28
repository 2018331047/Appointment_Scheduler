import 'package:appointment_scheduler/screens/initScreens/homeScreen.dart';
import 'package:appointment_scheduler/screens/teacherScreens/appointment_description.dart';
import 'package:appointment_scheduler/screens/teacherScreens/filtered_appointments.dart';
import 'package:appointment_scheduler/screens/teacherScreens/instant_appointments.dart';
import 'package:appointment_scheduler/screens/teacherScreens/map_screen.dart';

import 'package:appointment_scheduler/utils/service/notification_service.dart';
import 'package:appointment_scheduler/utils/side_navigation.dart';

import 'package:appointment_scheduler/widgets/custom_widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

///Home Screen in teacher's perspective
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // index of the bottomNavigationBar
  int _selectedIndex = 0;
  // instance of authentication object of Firestore
  final _auth = FirebaseAuth.instance;
  // course list of all appointments. Further used to filter courses.
  late ValueNotifier<List<String>> courseList;
  // UID's of all the students added with teacher
  List<String> studentUids = [];
  // for holding student information
  late Map<String, dynamic> studentInfo;
  @override
  void initState() {
    getCourseList();
    getStudentList(_auth.currentUser!.uid);
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    courseList = ValueNotifier<List<String>>([]);
    super.initState();
  }

  /// A method to get course names for using in filtering appointments
  Future getCourseList() async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .get()
        .then((value) => value.docs.forEach((element) {
              courseList.value.add(element['course title']);
            }));
    //converting to set to remove duplicate strings
    courseList.value = courseList.value.toSet().toList();
  }

  /// Method to listen for notifications
  listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  /// Method to do something if notifcation is clicked
  /// currently it isn't doing anything. Waiting for further extension
  onClickedNotification(String? payload) => debugPrint("do nothing");

  //A notifer to check if the teacher is active or not
  ValueNotifier<bool> statusNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Change active status if we exit the application
        await changeActiveStatus(_auth.currentUser!.uid, false);
        return true;
      },
      child: ValueListenableBuilder(
          valueListenable: statusNotifier,
          builder: (context, value, _) {
            return Scaffold(
              floatingActionButton: (_selectedIndex == 1)
                  ? Container()
                  : FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoogleMapView(
                              appointmentType: (statusNotifier.value)
                                  ? 'instant appointments'
                                  : 'appointments',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on_outlined),
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black,
                      label: const Text("See Location"),
                    ),
              appBar: AppBar(
                title: Text(
                  (statusNotifier.value)
                      ? "You are now Online"
                      : "Appointment Scheduler",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black, size: 30),
                centerTitle: true,
                actions: [
                  ValueListenableBuilder(
                      valueListenable: statusNotifier,
                      builder: (context, value, _) {
                        return Switch(
                            activeColor: Colors.grey[200],
                            activeTrackColor: Colors.greenAccent[700],
                            inactiveThumbColor: Colors.grey[200],
                            inactiveTrackColor: Colors.red[400],
                            value: statusNotifier.value,
                            onChanged: (value) {
                              statusNotifier.value = value;
                              changeActiveStatus(_auth.currentUser!.uid, value);
                            });
                      }),
                ],
              ),
              backgroundColor:
                  (statusNotifier.value) ? Colors.green[300] : Colors.grey[300],
              drawer: SideNav(),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                      valueListenable: courseList,
                      builder: (context, value, _) {
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton(
                                  onSelected: (String value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FilteredAppointments(
                                                    index: _selectedIndex,
                                                    courseName: value)),
                                      ),
                                  icon: Icon(Icons.filter_list_rounded),
                                  iconSize: 30,
                                  itemBuilder: (context) => courseList.value
                                      .map((e) => PopupMenuItem<String>(
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList()),
                            ),
                            ValueListenableBuilder(
                                valueListenable: statusNotifier,
                                builder: (context, value, _) {
                                  return (statusNotifier.value)
                                      ? InstantAppointments(
                                          index: _selectedIndex)
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('appointments')
                                                .orderBy('date')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final User user =
                                                  _auth.currentUser!;

                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else {
                                                List<DocumentSnapshot>
                                                    requestedAppointments =
                                                    snapshot.data!.docs
                                                        .where((element) =>
                                                            element['status'] ==
                                                                "requested" &&
                                                            element['other id'] ==
                                                                user.uid &&
                                                            DateFormat(
                                                                    'MM/dd/yyyy HH:mm a')
                                                                .parse(
                                                                    "${element['date']} ${element['time']}")
                                                                .isAfter(
                                                                    DateTime
                                                                        .now()))
                                                        .toList();
                                                List<DocumentSnapshot>
                                                    acceptedAppointments =
                                                    snapshot.data!.docs
                                                        .where((element) =>
                                                            element['status'] ==
                                                                "accepted" &&
                                                            element['other id'] ==
                                                                user.uid &&
                                                            DateFormat(
                                                                    'MM/dd/yyyy HH:mm a')
                                                                .parse(
                                                                    "${element['date']} ${element['time']}")
                                                                .isAfter(
                                                                    DateTime
                                                                        .now()))
                                                        .toList();

                                                return (_selectedIndex == 0)
                                                    ? ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            requestedAppointments
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          DocumentSnapshot
                                                              requestedAppointment =
                                                              requestedAppointments[
                                                                  index];
                                                          DateTime date = DateFormat(
                                                                  'MM/dd/yyyy HH:mm a')
                                                              .parse(
                                                                  "${requestedAppointment['date']} ${requestedAppointment['time']}");
                                                          return (requestedAppointments
                                                                  .isEmpty)
                                                              ? Center(
                                                                  child: Text(
                                                                      "No appointments"),
                                                                )
                                                              : AppointmentCard(
                                                                  courseName:
                                                                      requestedAppointment[
                                                                          'course title'],
                                                                  id: requestedAppointment
                                                                      .id,
                                                                  isRequested:
                                                                      true,
                                                                  name: requestedAppointment[
                                                                      'student name'],
                                                                  date: DateFormat
                                                                          .MMMEd()
                                                                      .format(
                                                                          date),
                                                                  time: requestedAppointment[
                                                                      'time'],
                                                                  title: requestedAppointment[
                                                                      'title'],
                                                                  image: requestedAppointment[
                                                                      'student image'],
                                                                  navigation:
                                                                      () async {
                                                                    await getStudentData(
                                                                        requestedAppointment[
                                                                            'student id']);
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AppointmentDescription(
                                                                          courseName:
                                                                              requestedAppointment['course title'],
                                                                          accepted:
                                                                              false,
                                                                          appointmentID:
                                                                              requestedAppointment.id,
                                                                          name:
                                                                              requestedAppointment['student name'],
                                                                          title:
                                                                              requestedAppointment['title'],
                                                                          image:
                                                                              requestedAppointment['student image'],
                                                                          date:
                                                                              DateFormat.MMMEd().format(date),
                                                                          dept:
                                                                              studentInfo['dept'],
                                                                          description:
                                                                              requestedAppointment['description'],
                                                                          lat: requestedAppointment[
                                                                              'lat'],
                                                                          long:
                                                                              requestedAppointment['long'],
                                                                          regNo:
                                                                              studentInfo['reg'],
                                                                          time:
                                                                              requestedAppointment['time'],
                                                                          phone:
                                                                              studentInfo['phone'],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                        })
                                                    : ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            acceptedAppointments
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          DocumentSnapshot
                                                              acceptedAppointment =
                                                              acceptedAppointments[
                                                                  index];
                                                          DateTime date = DateFormat(
                                                                  'MM/dd/yyyy HH:mm a')
                                                              .parse(
                                                                  "${acceptedAppointment['date']} ${acceptedAppointment['time']}");

                                                          return (acceptedAppointments
                                                                  .isEmpty)
                                                              ? Center(
                                                                  child: Text(
                                                                      "No appointments"),
                                                                )
                                                              : AppointmentCard(
                                                                  courseName: acceptedAppointment[
                                                                      'course title'],
                                                                  id: acceptedAppointment
                                                                      .id,
                                                                  name: acceptedAppointment[
                                                                      'student name'],
                                                                  date: DateFormat
                                                                          .MMMEd()
                                                                      .format(
                                                                          date),
                                                                  time: acceptedAppointment[
                                                                      'time'],
                                                                  title: acceptedAppointment[
                                                                      'title'],
                                                                  image: acceptedAppointment[
                                                                      'student image'],
                                                                  navigation:
                                                                      () async {
                                                                    await getStudentData(
                                                                        acceptedAppointment[
                                                                            'student id']);
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AppointmentDescription(
                                                                          courseName:
                                                                              acceptedAppointment['course title'],
                                                                          accepted:
                                                                              true,
                                                                          appointmentID:
                                                                              acceptedAppointment.id,
                                                                          name:
                                                                              acceptedAppointment['student name'],
                                                                          title:
                                                                              acceptedAppointment['title'],
                                                                          image:
                                                                              acceptedAppointment['student image'],
                                                                          date:
                                                                              DateFormat.MMMEd().format(date),
                                                                          dept:
                                                                              studentInfo['dept'],
                                                                          description:
                                                                              acceptedAppointment['description'],
                                                                          lat: acceptedAppointment[
                                                                              'lat'],
                                                                          long:
                                                                              acceptedAppointment['long'],
                                                                          regNo:
                                                                              studentInfo['reg'],
                                                                          time:
                                                                              acceptedAppointment['time'],
                                                                          phone:
                                                                              studentInfo['phone'],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                        });
                                              }
                                            },
                                          ),
                                        );
                                }),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        );
                      }),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                elevation: 0,
                backgroundColor: Colors.grey[100],
                showUnselectedLabels: false,
                fixedColor: Colors.black,
                iconSize: 30,
                selectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    activeIcon: Icon(Icons.event_rounded),
                    icon: Icon(
                      Icons.event_outlined,
                    ),
                    label: "Requested",
                  ),
                  BottomNavigationBarItem(
                      activeIcon: Icon(Icons.event_available_rounded),
                      icon: Icon(
                        Icons.event_available_outlined,
                      ),
                      label: "Accepted")
                ],
              ),
            );
          }),
    );
  }

  /// Method to change teacher's active status
  Future changeActiveStatus(String id, bool value) async {
    studentUids.forEach((element) async {
      (value)
          ? await FirebaseFirestore.instance
              .collection('students')
              .doc(element)
              .collection('addedTeacher')
              .doc(id)
              .update({'status': "active"})
          : await FirebaseFirestore.instance
              .collection('students')
              .doc(element)
              .collection('addedTeacher')
              .doc(id)
              .update({'status': "inactive"});
    });
  }

  /// Method for getting student's data
  Future getStudentData(String id) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) => studentInfo = value.data()!);
  }

  /// Method for getting the list of students added the teacher
  Future getStudentList(String id) async {
    await FirebaseFirestore.instance.collection('teachers').doc(id).get().then(
        (value) => value['addedStudent']
            .forEach((element) => studentUids.add(element)));
  }
}
