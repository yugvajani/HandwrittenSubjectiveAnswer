import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:paper_evaluation_app/teacher/question_paper_list.dart';
import 'package:paper_evaluation_app/teacher/subject/subject_detail_screen.dart';
import '../teacher_db.dart';
// import 'package:paper_evaluation_app/authentication/user_management.dart';
// import '.../authentication/user_management.dart';

class SubjectListView extends StatefulWidget {
  // SubjectListView(){
  //   user = await FirebaseAuth.instance.currentUser();
  // }

  @override
  _SubjectListViewState createState() => _SubjectListViewState();
}

class _SubjectListViewState extends State<SubjectListView> {
  // FirebaseUser user;

  // void initState() async{
  //   super.initState();
  //   user = await UserManagement().getUser();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TeacherDB().getSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child : CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<String> subjectList = snapshot.data;
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
              height: MediaQuery.of(context).size.height-235,
              child: Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: ListView.builder(
                    itemCount: subjectList.length,
                    padding: EdgeInsets.only(top:0),
                    itemBuilder: (context, index) {
                      return Container(
                        // elevation: 5,
                        child: Container(
                          height: 80,
                          child: Container(
                            child: ListTile(
                              leading: const Icon(Icons.auto_stories),
                              tileColor: Colors.white,
                              title: Text('${subjectList[index]}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubjectDetailScreen(subjectList[index])),
                                );
                              },
                            ),
                            
                          ),
                        ),
                      );
                    }),
              ),
            );
          } else
            return Container();
        });
  }
}
