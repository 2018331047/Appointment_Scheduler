import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//recieves all the necessary fields for appointments and adds to the appointment collection in firebase
class AddAppointment {
  final _auth = FirebaseAuth.instance;

  final String otherId;

  final String title;
  final String date;
  final String status;
  final String time;

  final String teacherName;
  final String studentName;
  final double lat;
  final double long;
  final String description;
  final String course;
  final String picStu;
  final String pictea;

  AddAppointment(
      this.otherId,
      this.title,
      this.date,
      this.status,
      this.teacherName,
      this.studentName,
      this.lat,
      this.long,
      this.time,
      this.description,
      this.course,
      this.picStu,
      this.pictea);

  CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');
  Future<void> addAppointment() {
    final User user = _auth.currentUser!;

    return appointments.add({
      'other id': otherId,
      'student id': user.uid,
      'title': title,
      'date': date,
      'status': status,
      'teacherName': teacherName,
      'student name': studentName,
      'lat': lat,
      'long': long,
      'time': time,
      'description': description,
      'course title': course,
      'student image': picStu,
      'teacher image': pictea,
    });
  }
}
