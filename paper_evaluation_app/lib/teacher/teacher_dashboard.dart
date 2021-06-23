import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/teacher/subject/new_subject.dart';
import 'package:paper_evaluation_app/teacher/subject/subject_list.dart';
import '../authentication/user_management.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  void _startAddNewSubject(BuildContext ctx, var scaffoldKey) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewSubject(ctx, scaffoldKey),
            // onTap: (){},
            // behavior: HitTestBehavior.opaque,
          );
        });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6F35A5),
      appBar: AppBar(
        backgroundColor: Color(0xFF6F35A5),
        elevation: 0,
        title: Text(
          "Teacher Dashboard",
          style: TextStyle(color: Colors.white,fontSize: 24),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(
                child: Text("Sign Out"),
                value: "Signout",
              ),
            ],
            onSelected: (value) {
                UserManagement().signOut(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height-130, 
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubjectListView(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: ButtonTheme(
                        minWidth: 300.0,
                        height: 50.0,
                        child: Container(
                          margin: const EdgeInsets.only(top: 15.0),
                          child: RaisedButton(
                            color: Color(0xFF6F35A5),
                            textColor: Colors.white,
                            child: Text('Add Subject'),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              _startAddNewSubject(context, _scaffoldKey);
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
