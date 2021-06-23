import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/authentication/user_management.dart';

class AttemptedQuestionWiseMarks extends StatelessWidget {
  String extractedAnswerText;
  String predictedMarks;
  String questionNumber;

  AttemptedQuestionWiseMarks(this.extractedAnswerText, this.predictedMarks,this.questionNumber);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6F35A5),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF6F35A5),
        title: Text(
          questionNumber,
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
      body: Padding(
        padding: const EdgeInsets.only(top:60.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
          height: MediaQuery.of(context).size.height-100,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top:200.0,left: 20,right: 20),
            child: Column(
              children: [
                Text(
                  'Extracted Text: ',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height:20),
                Text(
                  extractedAnswerText,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Marks Obtained: ',
                  style: TextStyle(fontSize: 18),
                  ),
                Text(
                  predictedMarks,
                  style: TextStyle(fontSize: 18),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
