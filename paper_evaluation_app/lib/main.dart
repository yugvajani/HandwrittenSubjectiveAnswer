import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/splash_screen.dart';
import './teacher/teacher_dashboard.dart';
import './student/student_dashboard.dart';
import './authentication/login_screen.dart';
import './authentication/signup_screen.dart';
import './authentication/user_management.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null)
      return 'Not Logged In';
    else {
      String role;
      await UserManagement().getUserRole(user).then((value) => role = value);
      return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    Map<int, Color> color = {
      50: Color.fromRGBO(136, 14, 79, .1),
      100: Color.fromRGBO(136, 14, 79, .2),
      200: Color.fromRGBO(136, 14, 79, .3),
      300: Color.fromRGBO(136, 14, 79, .4),
      400: Color.fromRGBO(136, 14, 79, .5),
      500: Color.fromRGBO(136, 14, 79, .6),
      600: Color.fromRGBO(136, 14, 79, .7),
      700: Color.fromRGBO(136, 14, 79, .8),
      800: Color.fromRGBO(136, 14, 79, .9),
      900: Color.fromRGBO(136, 14, 79, 1),
    };
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
            color: MaterialColor(0xff1a237e, color),
            textTheme: TextTheme(
                title: TextStyle(color: Colors.white, fontSize: 20),
                button: TextStyle(fontSize: 15, color: Colors.white))),
        accentColor: MaterialColor(0xff00bcd4, color),
        primaryColor: Colors.white,
        // buttonTheme: ButtonThemeData(buttonColor: MaterialColor(0xff00bcd4, color),),
        buttonColor: MaterialColor(0xff00bcd4, color),
      ),
      home: FutureBuilder<String>(
          future: getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else {
              if (snapshot.hasData) {
                // Timer(Duration(seconds: 10),(){print("complete");});
                if (snapshot.data == 'Not Logged In')
                  return LoginScreen();
                else if (snapshot.data == 'Teacher')
                  return TeacherDashboard();
                else
                  return StudentDashboard();
              } else
                return Container();
            }
          }),
      routes: <String, WidgetBuilder>{
        '/loginpage': (BuildContext context) => new MyApp(),
        '/signuppage': (BuildContext context) => new SignupScreen(),
        '/teacher_dashboard': (BuildContext context) => new TeacherDashboard(),
        '/student_dashboard': (BuildContext context) => new StudentDashboard(),
      },
    );
  }
}
