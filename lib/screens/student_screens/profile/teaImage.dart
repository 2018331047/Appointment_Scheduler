import 'package:appointment_scheduler/database_service.dart/firebaseStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart';
import 'dart:io';

class TeacherImage extends StatefulWidget {
  const TeacherImage({Key? key}) : super(key: key);

  @override
  _TeacherImageState createState() => _TeacherImageState();
}

class _TeacherImageState extends State<TeacherImage> {
  //getting the previous teacher profile picture and exchanging with the new one
  final _auth = FirebaseAuth.instance;
  String url =
      "https://monomousumi.com/wp-content/uploads/anonymous-user-3.png";
  Future getUrl() async {
    late DocumentSnapshot docu;
    final User? user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection('teachers')
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

  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    getUrl();
    Size size = MediaQuery.of(context).size;
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 130, right: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: size.height / 2,
              width: size.width / 2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                    image: NetworkImage(url), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 200, left: 300),
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  selectFile();
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          title: Text("Upload Profile Picture"),
                          content: SingleChildScrollView(
                              child: Column(
                            children: [
                              Text('Do you want to upload this image?'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      UploadFile();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'UPLOAD',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))));
                }),
          ),
        ),
      ],
    );
  }

//selecting the new image file
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

//uploading the new image
  Future UploadFile() async {
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';
    task = FirebaseApi.uploadFile(destination, file!);

    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      url = urlDownload;
    });
    final User user = _auth.currentUser!;
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(user.uid)
        .update({
      'image': urlDownload,
    });
    var collection = FirebaseFirestore.instance.collection('appointments');
    var querySnapshots = await collection.get();
    for (var doc in querySnapshots.docs) {
      if (doc['other id'] == user.uid)
        await doc.reference.update({
          'teacher image': urlDownload,
        });
    }
  }
}
