// import 'package:flutter/material.dart';
// import 'package:paper_evaluation_app/teacher/question_paper/question_paper_list.dart';
// import '../teacher_db.dart';
// // import 'package:intl/intl.dart';

// class NewQuestion extends StatefulWidget {
//   final BuildContext mainContext;
//   final GlobalKey scaffoldKey;
//   final String questionPaperName;
//   NewQuestion(this.questionPaperName, this.mainContext, this.scaffoldKey);

//   @override
//   _NewQuestionState createState() => _NewQuestionState();
// }

// class _NewQuestionState extends State<NewQuestion> {
//   final nameController = TextEditingController();
//   // var subjectAdded ;

//   Future<void> _submitData() async {
//     // if (nameController.text.isNotEmpty) {
//     //   await TeacherDB()
//     //       .addQuestionPaper(nameController.text, widget.questionPaperName,context, widget.scaffoldKey);
//     //   Scaffold.of(widget.mainContext).setState(() {

//     //   });
//     print("To do add code");
//     // State c = widget.scaffoldKey.currentState;
//     // c.
//     // Scaffold.of(context).build(context);
//     // BuildContext c = widget.scaffoldKey.currentContext;
//     // Scaffold.of(c).build(c);
//     // State c = widget.scaffoldKey.currentContext;
//     // Scaffold.of(c).build(c);
//     // Navigator.of(widget.mainContext).pushReplacementNamed('/subje'); TODO
//     // setState(() {});
//   }
//   // return subjectadded;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Card(
//         elevation: 5,
//         child: Container(
//           padding: EdgeInsets.only(
//               top: 10,
//               left: 10,
//               right: 10,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Enter Question'),
//                 controller: nameController,
//                 // onSubmitted: (_) => __submitData(),
//               ),
//               RaisedButton(
//                   onPressed: _submitData,
//                   child: Text(
//                     'Add Question',
//                   ),
//                   color: Theme.of(context).buttonColor,
//                   textColor: Theme.of(context).textTheme.button.color),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
