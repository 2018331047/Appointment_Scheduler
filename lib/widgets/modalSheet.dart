import 'package:appointment_scheduler/screens/student_screens/OTHERS/scanQR.dart';
import 'package:appointment_scheduler/widgets/createApp.dart';
import 'package:flutter/material.dart';

//shows the modal sheet
class ShowModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .18,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Create Appointments',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();

              showDialog<void>(
                context: context,
                builder: (_) {
                  return CreateAppointment();
                },
              );
            },
          ),
          ListTile(
            title: Text(
              'Add Teacher',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ScanQR()));
            },
          ),
        ],
      ),
    );
  }
}
