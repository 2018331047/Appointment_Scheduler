import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// implements the upper part which contains the user profile pic of main drawer
class Upper extends StatefulWidget {
  const Upper({Key? key}) : super(key: key);

  @override
  _UpperState createState() => _UpperState();
}

class _UpperState extends State<Upper> {
  final _auth = FirebaseAuth.instance;
  String url =
      "https://monomousumi.com/wp-content/uploads/anonymous-user-3.png";
  Future getUrl() async {
    late DocumentSnapshot docu;
    final User? user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection('students')
        .doc(user!.uid)
        .get()
        .then((value) {
      docu = value;
    });
    if (mounted) {
      setState(() {
        url = docu['image'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(docu['image']);
    getUrl();

    return Column(
      children: [
        SizedBox(
          height: 90,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(left: 45),
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(url),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
