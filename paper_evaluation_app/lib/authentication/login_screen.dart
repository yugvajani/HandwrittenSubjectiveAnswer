import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paper_evaluation_app/authentication/user_management.dart';
import 'package:paper_evaluation_app/components/rounded_button.dart';
import 'package:paper_evaluation_app/components/rounded_input_field.dart';
import 'package:paper_evaluation_app/components/rounded_password_field.dart';

import 'background.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  setState(() {
                    _email = value;
                    print(_email);
                  });
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                    print(_password);
                  });
                },
              ),
              RoundedButton(
                text: "LOGIN",
                press: () async {
                  if (_email != null && _password != null) {
                    if (_email.isNotEmpty && _password.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      )
                          .then((authUser) {
                        var user = authUser.user;
                        UserManagement().getUserRole(user).then((userRole) {
                          print("user role from func = $userRole");
                          if (userRole == 'Teacher') {
                            Navigator.of(context)
                                .pushReplacementNamed('/teacher_dashboard');
                            print('Hello Teacher');
                          } else
                            Navigator.of(context)
                                .pushReplacementNamed('/student_dashboard');
                        });
                      }).catchError((e) {
                        print("error $e");
                        String errorMessage;
                        switch (e.code) {
                          case "ERROR_INVALID_EMAIL":
                            errorMessage =
                                "Your email address appears to be malformed.";
                            break;
                          case "ERROR_WRONG_PASSWORD":
                            errorMessage = "Your password is wrong.";
                            break;
                          case "ERROR_USER_NOT_FOUND":
                            errorMessage =
                                "User with this email doesn't exist.";
                            break;
                          case "ERROR_USER_DISABLED":
                            errorMessage =
                                "User with this email has been disabled.";
                            break;
                          case "ERROR_TOO_MANY_REQUESTS":
                            errorMessage =
                                "Too many requests. Try again later.";
                            break;
                          case "ERROR_OPERATION_NOT_ALLOWED":
                            errorMessage =
                                "Signing in with Email and Password is not enabled.";
                            break;
                          default:
                            errorMessage = "An undefined Error happened.";
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(errorMessage),
                        ));
                      });
                    } else {
                      print("in login else");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error logging in"),
                      ));
                    }
                  } else {
                    print("in login else");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter fields"),
                    ));
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Text("Don't have an account? Sign up here!"),
                onPressed: () {
                  Navigator.of(context).pushNamed('/signuppage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
