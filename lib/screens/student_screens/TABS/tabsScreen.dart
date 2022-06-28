import 'dart:math';

import 'package:appointment_scheduler/screens/student_screens/TABS/accepted.dart';

import 'package:appointment_scheduler/screens/student_screens/TABS/people.dart';
import 'package:appointment_scheduler/screens/student_screens/TABS/requested.dart';
import 'package:appointment_scheduler/screens/student_screens/OTHERS/settings.dart';
import 'package:appointment_scheduler/utils/service/notification_service.dart';
import 'package:appointment_scheduler/widgets/appbar.dart';
import 'package:appointment_scheduler/widgets/main_drawer.dart';
import 'package:appointment_scheduler/widgets/modalSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final _auth = FirebaseAuth.instance;
  final List<Widget> _pages = [
    Accepted(),
    Requested(),
    People(),
  ];
  int _selectedPageIndex = 0;

  var Locator;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAvaillableTeachers(_auth.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getUrl();
    return Scaffold(
      appBar: AppBar(
        title: APPBAR(_selectedPageIndex),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => settings()),
              );
            },
            color: Colors.black,
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            label: 'Scheduled',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_outlined),
            label: 'Requested',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _getLocation();
          showModalBottomSheet<void>(
            context: context,
            builder: (_) {
              return ShowModal();
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Future getAvaillableTeachers(String id) async {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .collection('addedTeacher')
        .snapshots();

    stream.listen((value) {
      value.docs
          .where((element) => element['status'] == "active")
          .forEach((element) {
        NotificationApi.showNotification(
          body: "Can apply for instant appointment",
          id: Random().nextInt(10000),
          title: "${element['name']} is active now",
          payload: "active",
        );
      });
    });
  }
}
