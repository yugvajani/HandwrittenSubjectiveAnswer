import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paper_evaluation_app/student/teacher_list.dart';

import './send_image.dart';
import '../authentication/user_management.dart';
import 'attempted_papers_lists.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFF6F35A5),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Student Dashboard',
            style: TextStyle(fontSize: 24),
            ),
          bottom: TabBar(
            indicatorColor: Color(0xFFE1BEE7),
            labelColor: Color(0xFFE1BEE7),
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'View Teacher Lists',
              ),
              Tab(
                text: 'View Attempted Papers',
              ),
            ],
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
              child: TabBarView(
                children: <Widget>[
                TeacherListView(),
                AttemptedPapersListView(),
                ],
              ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}

