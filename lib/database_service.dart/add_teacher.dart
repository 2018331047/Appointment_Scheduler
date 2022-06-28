import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//recieves all the necessary info of a teacher and adds to the teacher collection in firebase
class AddUser2 {
  final _auth = FirebaseAuth.instance;

  final String userName;
  final String email;
  final String dept;
  final String designation;
  final String phone;

  AddUser2(
    this.userName,
    this.email,
    this.dept,
    this.designation,
    this.phone,
  );

  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');
  Future<void> addUser2() {
    final User user = _auth.currentUser!;
    return teachers.doc(user.uid).set({
      'user_name': userName,
      'uid': user.uid,
      'user type': 'teacher',
      'email': email,
      'dept': dept,
      'designation': designation,
      'phone': phone,
      'status': 'inactive',
      'image':
          "https://monomousumi.com/wp-content/uploads/anonymous-user-3.png",
      'authentication status': 'disabled',
    });
  }
}
