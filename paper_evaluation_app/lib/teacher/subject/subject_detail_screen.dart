import 'package:flutter/material.dart';

import '../question_paper/new_question_paper.dart';
import '../question_paper/question_paper_list.dart';

class SubjectDetailScreen extends StatefulWidget {

  final String subjectName;

  SubjectDetailScreen(this.subjectName);

  @override
  _SubjectDetailScreenState createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  void _startAddNewQuestionPaper(BuildContext ctx, var scaffoldKey) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewQuestionPaper(widget.subjectName,ctx, scaffoldKey),
            // onTap: (){},
            // behavior: HitTestBehavior.opaque,
          );
        });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var columnContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6F35A5),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.subjectName,
          style: TextStyle(fontSize: 24),
          ),
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
              height: MediaQuery.of(context).size.height-130, 
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context){ 
                      columnContext = context;
                      return QuestionPaperListView(widget.subjectName);
                      }
                  ),
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
                            child: Text('Add Question Paper'),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              _startAddNewQuestionPaper(columnContext, _scaffoldKey);
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
