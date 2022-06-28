import 'package:flutter/material.dart';

//creates the card in profile pages of users info
class BuildCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  BuildCard(this.title, this.icon, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.only(top: 9),
            child: Icon(
              icon,
              size: 21,
              color: Colors.grey[700],
            ),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 7),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 20,
                //fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          onTap: () {},
          //trailing: Icon(Icons.edit),
        ),
      ),
    );
  }
}
