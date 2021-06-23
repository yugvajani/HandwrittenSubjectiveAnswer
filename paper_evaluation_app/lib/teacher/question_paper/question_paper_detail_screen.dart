import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/teacher/teacher_db.dart';
import './question_list_view.dart';
import './new_question.dart';
import '../question_paper/question_paper_list.dart';
import 'load_csv.dart';

class QuestionPaperDetailScreen extends StatefulWidget {
  final String subjectName;
  final String questionPaperName;

  QuestionPaperDetailScreen(this.questionPaperName, this.subjectName);

  @override
  _QuestionPaperDetailScreenState createState() =>
      _QuestionPaperDetailScreenState();
}

class _QuestionPaperDetailScreenState extends State<QuestionPaperDetailScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var columnContext;
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
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(
                child: Text("Export as Excel"),
                value: "Excel",
              ),
            ],
            onSelected: (value) {
                TeacherDB().exportExcel(context, widget.subjectName, widget.questionPaperName);           
            },
          ),
        ],
        backgroundColor: Color(0xFF6F35A5),
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
              height: MediaQuery.of(context).size.height - 130,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(60),
                      topLeft: Radius.circular(60)),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    columnContext = context;
                    return QuestionListView(
                        widget.subjectName, widget.questionPaperName);
                  }),
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
                            child: Text('Add Question'),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () async {
                              await TeacherDB().addQuestion(
                                  widget.subjectName,
                                  widget.questionPaperName,
                                  context,
                                  _scaffoldKey);
                              setState(() {});
                              // _scaffoldKey.currentState.showSnackBar(SnackBar(
                              //   content: Text('New Question Added'),
                              // ));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New Question Added'),));
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
