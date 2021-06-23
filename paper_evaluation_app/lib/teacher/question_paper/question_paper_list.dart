import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/teacher/question_paper/question_paper_detail_screen.dart';
import '../teacher_db.dart';

class QuestionPaperListView extends StatefulWidget {
  final String subjectName;

  @override
  _QuestionPaperListViewState createState() => _QuestionPaperListViewState();

  QuestionPaperListView(this.subjectName);
}

class _QuestionPaperListViewState extends State<QuestionPaperListView> {
  @override
  Widget build(BuildContext context) {
    // return Container(child: Text("Question papers of ${widget.subjectName}"));
    return FutureBuilder(
        future: TeacherDB().getQuestionPapers(widget.subjectName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            List<String> questionPaperList = snapshot.data;
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
              height: MediaQuery.of(context).size.height-235,
               child: questionPaperList.isEmpty ?Container(decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
                height: MediaQuery.of(context).size.height-235, child: Text("No question papers"),) :Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: ListView.builder(
                    itemCount: questionPaperList.length,
                    padding: EdgeInsets.only(top:0),
                    itemBuilder: (context, index) {
                      return Container(
                        // elevation: 5,
                        child: Container(
                          height: 80,
                          child: Container(
                            child: ListTile(
                              leading: const Icon(Icons.assignment),
                              tileColor: Colors.white,
                              title: Text('${questionPaperList[index]}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuestionPaperDetailScreen(questionPaperList[index],widget.subjectName)),
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
            return Container(height: MediaQuery.of(context).size.height * 0.8,);
        });
  }
}
