import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//recieves all the necessary info of a student and adds to the student collection in firebase
class AddUser {
  final _auth = FirebaseAuth.instance;

  final String userName;
  final String dept;
  final String session;
  final String reg;
  final String email;
  final String phone;

  AddUser(
    this.userName,
    this.dept,
    this.session,
    this.reg,
    this.email,
    this.phone,
  );

  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  Future<void> addUser() {
    final User user = _auth.currentUser!;
    return students.doc(user.uid).set({
      'user_name': userName,
      'dept': dept,
      'session': session,
      'reg': reg,
      'uid': user.uid,
      'user type': 'student',
      'email': email,
      'phone': phone,
      'image':
          "https://monomousumi.com/wp-content/uploads/anonymous-user-3.png",
      'authentication status': 'disabled',
    });
  }
}
