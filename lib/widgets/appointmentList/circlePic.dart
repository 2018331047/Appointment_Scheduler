import 'package:flutter/material.dart';

// shows the profile picture in the tile
class AcceptListBox extends StatefulWidget {
  String url;
  AcceptListBox(this.url);

  @override
  State<AcceptListBox> createState() => _AcceptListBoxState();
}

class _AcceptListBoxState extends State<AcceptListBox> {
  @override
  Widget build(BuildContext context) {
    //getUrl();
    return Padding(
      padding: const EdgeInsets.all(5),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.grey[400],
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          foregroundImage: NetworkImage(widget.url),
        ),
      ),
    );
  }
}
