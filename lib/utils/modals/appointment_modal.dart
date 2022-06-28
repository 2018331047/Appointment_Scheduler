import 'package:appointment_scheduler/utils/modals/student_modal.dart';

class AppointmentModal {
  final String title;
  final String description;
  final String time;
  final String date;
  final double lat;
  final double long;
  final StudentModal? studentInfo;

  AppointmentModal({
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.lat,
    required this.long,
    this.studentInfo,
  });
}
