import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

// kepps track in database who is connected with whom
//gets all the necessery info just after a student got connected to tecaher and adds infos to addedStudent arrayfield of
//teachers collection and addedTeacher collection of students collevtion
class Nested {
  final _auth = FirebaseAuth.instance;

  final String teacher;
  final String name;
  final String status;
  final String image;
  Nested(this.teacher, this.name, this.status, this.image);
//add infos in addedTeacher collection of students collection
  Future<void> addTeacher() async {
    final User user = _auth.currentUser!;

    await FirebaseFirestore.instance
        .collection('students')
        .doc(user.uid)
        .collection('addedTeacher')
        .doc(teacher)
        .set({
      'id': teacher,
      'name': name,
      'status': status,
      'image': image,
    });
    addStudent();
  }

// create an array to keep track which student is added to the particular teacher
  Future<void> addStudent() async {
    final User user = _auth.currentUser!;
    print('Inside');

    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacher)
        .update({
      'addedStudent': FieldValue.arrayUnion([user.uid])
    });
  }
}
