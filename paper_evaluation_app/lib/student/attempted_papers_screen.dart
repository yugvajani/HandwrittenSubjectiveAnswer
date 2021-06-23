import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/authentication/user_management.dart';
import 'package:paper_evaluation_app/student/attempted_question_wise_marks.dart';
import 'package:paper_evaluation_app/student/student_db.dart';

class AttemptedPapersScreen extends StatelessWidget {
  String attemptedPaperPath;

  AttemptedPapersScreen(this.attemptedPaperPath);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6F35A5),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF6F35A5),
        title: Text(
          attemptedPaperPath.substring(attemptedPaperPath.lastIndexOf('/')+1,attemptedPaperPath.length),
          style: TextStyle(fontSize: 24),
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
      body: FutureBuilder(
        future: StudentDB().getAttemptedPaperQuestions(attemptedPaperPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            Map<String, dynamic> questionList = snapshot.data;
            var keysList = questionList.keys.toList();
            print(keysList);
            print(questionList);
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(top:60.0),
                child: Container(
                  padding: const EdgeInsets.only(top:60.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
                  height: MediaQuery.of(context).size.height-235,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height-270,
                        child: ListView.builder(
                            itemCount: keysList.length,
                            padding: EdgeInsets.only(top:0),
                            itemBuilder: (context, index) {
                              return questionList.keys.elementAt(index) ==
                                            'finished_attempt' ||
                                        questionList.keys.elementAt(index) ==
                                            'total_marks'
                                            ?
                              Container()
                              :
                              Container(
                                // elevation: 5,
                                child: Container(
                                  height: 80,
                                  child: Container(
                                    child: ListTile(
                                      leading: const Icon(Icons.auto_stories),
                                      tileColor: Colors.white,
                                      title: Text(
                                                '${questionList.keys.elementAt(index)}'),
                                            trailing: Text(
                                                '${questionList[keysList[index]].values.elementAt(0)}'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                          AttemptedQuestionWiseMarks(
                                                              questionList[
                                                                      keysList[index]]
                                                                  .keys
                                                                  .elementAt(0),
                                                              questionList[
                                                                      keysList[index]]
                                                                  .values
                                                                  .elementAt(0).toString(),'${questionList.keys.elementAt(index)}'))
                                        );
                                      },
                                    ),  
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Marks: ',
                        style: TextStyle(fontSize: 20),
                        ),
                      Text(
                        '${questionList['total_marks']}',
                        style: TextStyle(fontSize: 20),
                        )
                    ],
                  ),
                ),
                    ],
                  ),
                ),
              ),
            );
            
          } else
            return Container();
        },
      ),
    );
  }
}
