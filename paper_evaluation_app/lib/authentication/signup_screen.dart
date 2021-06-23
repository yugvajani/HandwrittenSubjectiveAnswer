import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paper_evaluation_app/components/rounded_button.dart';
import 'package:paper_evaluation_app/components/rounded_input_field.dart';
import 'package:paper_evaluation_app/components/rounded_name_field.dart';
import 'package:paper_evaluation_app/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paper_evaluation_app/authentication/user_management.dart';

import 'back.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _email;
  String _password;
  String _name;
  String _role;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      // key: _scaffoldKey ,
      body: Back(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.35,
              ),
              RoundedNameField(
                onChanged: (value) {
                  setState(() {
                    _name = value;
                    print(_name);
                  });
                },
              ),
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
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.128,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color(0xFFF1E6FF),
                    shape: RoundedRectangleBorder(
                      // side: BorderSide(width: 0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  child: new DropdownButton<String>(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        SizedBox(width: 20,),
                        Icon(Icons.person_pin_circle_outlined, color: Colors.deepPurple,),
                        SizedBox(width: 20,),
                        Text("Role",textAlign: TextAlign.end,),
                      ],
                    ),
                    value: _role,
                    items: <String>['Teacher', 'Student'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value,),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _role = value;
                      });
                      print(_role);
                    },
                  ),
                ),
              ),
              RoundedButton(
                text: "SIGNUP",
                press: () {
                  setState(() {
                    _isLoading = true;
                  });
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((signedInUser) {
                    UserManagement()
                        .storeNewUser(signedInUser.user, _role, _name, context);
                  }).catchError((e) {
                    print(e);
                    // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields"),));
                    // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please fill all fields")));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Signing Up"),));
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Text("Already have an account? Login here!"),
                onPressed: () {
                  // Navigator.of(context).pushReplacementNamed('/loginpage');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
