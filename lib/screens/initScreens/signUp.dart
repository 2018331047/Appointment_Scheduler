import 'package:appointment_scheduler/screens/initScreens/otp.dart';

import 'package:appointment_scheduler/screens/initScreens/signIn.dart';

import 'package:appointment_scheduler/widgets/loginButton/deco.dart';

import 'package:appointment_scheduler/widgets/loginScreenTitle/titleOne.dart';
import 'package:appointment_scheduler/widgets/loginScreenTitle/titleThree.dart';
import 'package:appointment_scheduler/widgets/loginScreenTitle/titleTwo.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String err = "OTP sent";
  EmailAuth emailAuth = new EmailAuth(sessionName: "Appointment Scheduler");

  //sends otp to verify user
  void sendOtp() async {
    bool res = await emailAuth.sendOtp(
        recipientMail: emailEditingController.text, otpLength: 6);
  }

  bool check = false;
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final fullNameEditingController = new TextEditingController();
  //late final String name;
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 1,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Title1('SignUp'),
              SizedBox(
                height: size.height * 0.03,
              ),
              Title2('Hi,', 'Welcome!'),
              SizedBox(
                height: size.height * 0.004,
              ),
              Title3('Please sign up to continue'),
              SizedBox(height: size.height * 0.01),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(right: 20, top: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        //autofocus: false,
                        controller: fullNameEditingController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("Full Name cannot be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid name(Min. 3 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          fullNameEditingController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        controller: emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailEditingController.text = value!;
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
                        controller: passwordEditingController,
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
                          passwordEditingController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                          autofocus: false,
                          controller: confirmPasswordEditingController,
                          obscureText: true,
                          validator: (value) {
                            if (confirmPasswordEditingController.text !=
                                passwordEditingController.text) {
                              return "Password don't match";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            confirmPasswordEditingController.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key),
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                          child: Row(
                        children: [
                          MaterialButton(
                            textColor: Colors.white,
                            onPressed: () {
                              check = false;

                              if (_formKey.currentState!.validate()) {
                                sendOtp();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OTP(
                                        emailEditingController.text,
                                        passwordEditingController.text,
                                        check,
                                        fullNameEditingController.text)));
                              }
                            },
                            padding: const EdgeInsets.all(0),
                            child: Deco('SIGN UP AS STUDENT'),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          MaterialButton(
                            textColor: Colors.white,
                            onPressed: () {
                              check = true;
                              if (_formKey.currentState!.validate()) {
                                sendOtp();
                                Fluttertoast.showToast(msg: err);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OTP(
                                        emailEditingController.text,
                                        passwordEditingController.text,
                                        check,
                                        fullNameEditingController.text)));
                              }
                            },
                            padding: const EdgeInsets.all(0),
                            child: Deco('SIGN UP AS TEACHER'),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 95),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: "Sign In",
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
                                    builder: (context) => SignIn()));
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
}
