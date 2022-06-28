import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String hint;
  TextInput(
    this.hint,
  );
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.only(left: 10),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 10),
            labelText: hint,
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
