import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/teacher/question_paper/question_paper_list.dart';
import '../teacher_db.dart';
// import 'package:intl/intl.dart';

class NewQuestionPaper extends StatefulWidget {
  final BuildContext mainContext;
  final GlobalKey scaffoldKey;
  final String subjectName;
  NewQuestionPaper(this.subjectName,this.mainContext, this.scaffoldKey);

  

  @override
  _NewQuestionPaperState createState() => _NewQuestionPaperState();
}

class _NewQuestionPaperState extends State<NewQuestionPaper> {
  final nameController = TextEditingController();
  // var subjectAdded ;

  Future<void> _submitData(context) async {
    if (nameController.text.isNotEmpty) {
      await TeacherDB()
          .addQuestionPaper(nameController.text, widget.subjectName,context, widget.scaffoldKey);
      Scaffold.of(widget.mainContext).setState(() {
        
      });
    
      // State c = widget.scaffoldKey.currentState;
      // c.
      // Scaffold.of(context).build(context);
      // BuildContext c = widget.scaffoldKey.currentContext;
      // Scaffold.of(c).build(c);
      // State c = widget.scaffoldKey.currentContext;
      // Scaffold.of(c).build(c);
      // Navigator.of(widget.mainContext).pushReplacementNamed('/subje'); TODO
      // setState(() {});
    }
    else{
      print("in else");
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the name of question paper please"),));
    }
    // return subjectadded;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name of Question Paper'),
                controller: nameController,
                // onSubmitted: (_) => __submitData(),
              ),
              RaisedButton(
                  onPressed: (){_submitData(context);},
                  child: Text(
                    'Add Question Paper',
                  ),
                  color: Color(0xFF6F35A5),
                  textColor: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
