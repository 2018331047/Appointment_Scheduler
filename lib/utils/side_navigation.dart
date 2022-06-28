import 'package:appointment_scheduler/screens/teacherScreens/showQR.dart';
import 'package:appointment_scheduler/widgets/CALENDER/calender.dart';
import 'package:appointment_scheduler/screens/student_screens/profile/teaProfile.dart';
import 'package:appointment_scheduler/screens/student_screens/OTHERS/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideNav extends StatefulWidget {
  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  Widget navigationTiles(
      {@required String? title,
      @required IconData? icon,
      Function()? onPressed}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(title!),
      onTap: onPressed,
    );
  }

  final _auth = FirebaseAuth.instance;
  String url =
      "https://monomousumi.com/wp-content/uploads/anonymous-user-3.png";
  Future getUrl() async {
    late DocumentSnapshot docu;
    final User? user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(user?.uid)
        .get()
        .then((value) {
      docu = value;
    });
    if (mounted) {
      setState(() {
        url = docu['image'];
        print(url);
      });
    }
  }

  late String na;

  Future<void> getName(id, context) async {
    //final User user = _auth.currentUser!;
    late DocumentSnapshot docu;

    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(id)
        .get()
        .then((value) {
      docu = value;
    });
    //String name = docu['user_name'] ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherProfile(
          docu['user_name'] ?? '',
          docu['email'] ?? ' ',
          docu['dept'],
          docu['designation'] ?? ' ',
          docu['phone'],
        ),
      ),
    );
    // print(name);
    //na = docu['user_name'];
  }

  @override
  Widget build(BuildContext context) {
    getUrl();
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            CircleAvatar(
              radius: 60,
              foregroundImage: NetworkImage(url),
            ),
            SizedBox(
              height: 30,
            ),
            /*Text(
              "USER NAME",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'user@gmail.com',
              style: TextStyle(color: Colors.grey[700]),
            ),*/
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 1,
              thickness: 2,
              indent: 5,
              endIndent: 10,
            ),
            SizedBox(
              height: 10,
            ),
            navigationTiles(
              icon: Icons.person,
              title: "Profile",
              onPressed: () async {
                final User user = _auth.currentUser!;
                getName(user.uid, context);
              },
            ),
            navigationTiles(
                icon: Icons.qr_code,
                title: "QR Code",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowQR()),
                  );
                }),
            navigationTiles(
                icon: Icons.calendar_today,
                title: "Calendar",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Calendar()),
                  );
                }),
            navigationTiles(
              icon: Icons.settings,
              title: "Settings",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => settings()),
                );
              },
            ),
            /*navigationTiles(
              icon: Icons.logout,
              title: "Logout",
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (route) => false);
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
