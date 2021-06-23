import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/student/student_db.dart';
import 'package:paper_evaluation_app/student/subject_list_screen.dart';


class TeacherListView extends StatefulWidget {
  @override
  _TeacherListViewState createState() => _TeacherListViewState();
}

class _TeacherListViewState extends State<TeacherListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StudentDB().getTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child : CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Map<String,String>> teacherList = snapshot.data;
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
              height: MediaQuery.of(context).size.height-235,
              child: Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: ListView.builder(
                    itemCount: teacherList.length,
                    padding: EdgeInsets.only(top:0),
                    itemBuilder: (context, index) {
                      return Container(
                        // elevation: 5,
                        child: Container(
                          height: 80,
                          child: Container(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              tileColor: Colors.white,
                              title: Text('${teacherList[index]['name']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      SubjectListScreen(teacherList[index]['uid'])),
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