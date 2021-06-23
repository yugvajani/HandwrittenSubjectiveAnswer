import 'package:flutter/material.dart';
import '../teacher_db.dart';
// import 'package:intl/intl.dart';

class NewSubject extends StatefulWidget {
  final BuildContext mainContext;
  final scaffoldKey;
  NewSubject(this.mainContext, this.scaffoldKey);

  @override
  _NewSubjectState createState() => _NewSubjectState();
}

class _NewSubjectState extends State<NewSubject> {
  final nameController = TextEditingController();
  // var subjectAdded ;

  Future<void> _submitData() async {
    if (nameController.text.isNotEmpty) {
      await TeacherDB()
          .addSubject(nameController.text, context, widget.scaffoldKey);
      Navigator.of(widget.mainContext).pushReplacementNamed('/teacher_dashboard');
      // setState(() {});
    }
    else{
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the name of subject please"),));
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name of Subject'),
                controller: nameController,
                // onSubmitted: (_) => __submitData(),
              ),
              RaisedButton(
                  onPressed: _submitData,
                  child: Text(
                    'Add Subject',
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
