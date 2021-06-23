import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/authentication/user_management.dart';
import 'package:paper_evaluation_app/student/question_screen.dart';
import 'package:paper_evaluation_app/student/student_db.dart';

class QuestionListScreen extends StatefulWidget {
  String teacherUid;
  String subjectName;
  String questionPaperName;

  QuestionListScreen(this.teacherUid, this.subjectName, this.questionPaperName);

  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF6F35A5),
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.questionPaperName,
            style: TextStyle(fontSize: 24),
            ),
          backgroundColor: Color(0xFF6F35A5),
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
            future: StudentDB().getQuestions(widget.teacherUid,
                widget.subjectName, widget.questionPaperName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                List<Map<String, bool>> questionList = snapshot.data;
                bool finished =
                questionList[questionList.length - 1]['finished_attempt'];
                questionList.removeAt(questionList.length - 1);
                print(questionList.length);
                return Container(
                    height: MediaQuery.of(context).size.height,
                    child:Padding(
                      padding: const EdgeInsets.only(top:60.0),
                      child: Container(
                        padding: EdgeInsets.only(top:60),
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height-300,
                              child: ListView.builder(
                                  itemCount: questionList.length,
                                  itemBuilder: (context, index) {
                                    return Material(
                                      color: Colors.white,
                                      elevation: 0,
                                      child: ListTile(
                                        title:
                                            Text('${questionList[index].keys.first}'),
                                        trailing: questionList[index]
                                                [questionList[index].keys.elementAt(0)]
                                            ? Icon(Icons.assignment_turned_in)
                                            : Icon(Icons.arrow_forward),
                                        onTap: () async {
                                          if (finished) {
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text('Finished attempt')));
                                          } else {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuestionScreen(
                                                            widget.teacherUid,
                                                            widget.subjectName,
                                                            widget.questionPaperName,
                                                            questionList[index]
                                                                .keys
                                                                .first)));
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    );
                                  }),
                            ),
                            finished
                        ? FlatButton(
                            onPressed: null, child: Text('Finished Attempt'))
                        : SizedBox(
                          height: 60,
                          width: 300,
                          child: RaisedButton(
                            color: Color(0xFF6F35A5),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                              onPressed: () async {
                                  await StudentDB().finishAttempt(
                                      widget.teacherUid,
                                      widget.subjectName,
                                      widget.questionPaperName);
                                  setState(() {
                                    
                                  });
                              },
                              child: Text(
                                'Finish attempt',
                                style: TextStyle(fontSize: 16),
                                ),
                            ),
                        )
                          ],
                        ),
                      ),
                    ),
                  
                );
              } else
                return Container();
            })
    );
  }
}
