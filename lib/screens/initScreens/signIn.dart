import 'package:appointment_scheduler/screens/initScreens/signUp.dart';
import 'package:appointment_scheduler/screens/moderatorScreens/tabscreen.dart';
import 'package:appointment_scheduler/screens/student_screens/OTHERS/resetPass.dart';
import 'package:appointment_scheduler/screens/student_screens/TABS/tabsScreen.dart';
import 'package:appointment_scheduler/screens/teacherScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:appointment_scheduler/widgets/loginButton/deco.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:appointment_scheduler/widgets/loginScreenTitle/titleOne.dart';
import 'package:appointment_scheduler/widgets/loginScreenTitle/titleThree.dart';
import 'package:appointment_scheduler/widgets/loginScreenTitle/titleTwo.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  late String status;
  String err = 'Account is not enabled';

//this method is used to identify the user type
  Future<void> getName(id) async {
    late DocumentSnapshot docu;
    String ID = id;
//checking if the user is student
    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) async {
      docu = value;
      if (docu.exists) {
        status = "student";
      } else {
        status = "teacher";
      }
      print(status);
      if (status == "student") {
        if (docu['authentication status'] == "disabled") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TabsScreen()));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignIn()));
          Fluttertoast.showToast(msg: err);
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TabsScreen()));
        }
      } else {
        // method is called to check whether the user is teacher or moderator
        getStatus(ID);
      }
    });
  }

//checking if the user is teacher or moderator
  Future<void> getStatus(id) async {
    late DocumentSnapshot docuu;
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(id)
        .get()
        .then((value) async {
      docuu = value;
      if (docuu.exists) {
        status = "teacher";
      } else {
        status = "moderator";
      }

      if (status == "teacher") {
        if (docuu['authentication status'] == "disabled") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignIn()));
          Fluttertoast.showToast(msg: err);
        } else if (docuu['authentication status'] == "enabled") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } else {
        //checking if the user is moderator
        late DocumentSnapshot docuuu;
        await FirebaseFirestore.instance
            .collection('moderator')
            .doc(id)
            .get()
            .then((value) async {
          docuuu = value;
          if (docuuu.exists) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Tabs()));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title1('Log In'),
              SizedBox(
                height: size.height * 0.05,
              ),
              Title2('Hi,', 'Good Day!'),
              SizedBox(
                height: size.height * 0.004,
              ),
              Title3('Please sign in to continue'),
              SizedBox(
                height: size.height * 0.03,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(right: 20, top: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      //TextInput('Email'),
                      //PassInput('Password'),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => showDialog<void>(
                            context: context,
                            builder: (_) {
                              return ResetPass();
                            },
                          ),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                backgroundColor: Colors.grey[200]),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 30),
                        child: MaterialButton(
                          textColor: Colors.white,
                          onPressed: () async {
                            signIn(
                                emailController.text, passwordController.text);
                          },
                          padding: const EdgeInsets.all(0),
                          child: Deco('LOGIN'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 95),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
            ],
          ),
        ),
      ),
    );
  }

//method to sign a user in
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                });
        final User user = _auth.currentUser!;

        getName(user.uid);
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
