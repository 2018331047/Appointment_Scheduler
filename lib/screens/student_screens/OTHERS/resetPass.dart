import 'package:appointment_scheduler/screens/initScreens/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPass extends StatelessWidget {
  final TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reset Password'),
      content: TextField(
        //autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        onSubmitted: (value) async {
          emailController.text = value;
          Navigator.of(context).pop();
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: emailController.text)
              .then((value) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (route) => false));
          //dept = value;
          //dept = value;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          // contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
