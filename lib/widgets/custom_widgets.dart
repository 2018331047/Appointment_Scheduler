import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final String courseName;
  final bool? isInstant;
  final bool? isRequested;
  final VoidCallback navigation;
  final String name;
  final String title;
  final String date;
  final String time;
  final String image;
  final String id;
  AppointmentCard({
    required this.navigation,
    required this.name,
    required this.title,
    required this.date,
    required this.time,
    this.isRequested,
    required this.image,
    required this.id,
    this.isInstant,
    required this.courseName,
  });

  Future acceptAppointment(String id) async {
    (isInstant != null)
        ? await FirebaseFirestore.instance
            .collection('instant appointments')
            .doc(id)
            .update({'status': "accepted"})
        : await FirebaseFirestore.instance
            .collection('appointments')
            .doc(id)
            .update({'status': "accepted"});
  }

  Future rejectAppointment(String id) async {
    (isInstant != null)
        ? await FirebaseFirestore.instance
            .collection('instant appointments')
            .doc(id)
            .delete()
        : await FirebaseFirestore.instance
            .collection('appointments')
            .doc(id)
            .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: (isRequested != null)
          ? DismissDirection.horizontal
          : DismissDirection.startToEnd,
      key: ObjectKey(id),
      background: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          alignment: Alignment.centerLeft,
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
              Icons.delete_forever,
              size: 40,
            ),
          ),
        ),
      ),
      secondaryBackground: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          alignment: Alignment.centerRight,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.done_rounded, size: 40),
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          acceptAppointment(id);
        } else {
          rejectAppointment(id);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: GestureDetector(
          onTap: navigation,
          child: Container(
            padding: EdgeInsets.all(10),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor:
                      (isRequested != null) ? Colors.blueAccent : Colors.green,
                  radius: 32,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 28,
                    foregroundImage: NetworkImage(image),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.purple[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                courseName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      Text(
                        time,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
