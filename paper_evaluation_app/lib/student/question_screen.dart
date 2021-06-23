import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/authentication/user_management.dart';
import 'package:paper_evaluation_app/student/send_image.dart';
import 'package:paper_evaluation_app/student/student_db.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class QuestionScreen extends StatefulWidget {
  String teacherUid;
  String subjectName;
  String questionPaperName;
  String questionNumber;

  QuestionScreen(this.teacherUid, this.subjectName, this.questionPaperName,
      this.questionNumber);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _image;

  String _text = "No text";

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF6F35A5),
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.questionNumber,
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
            future: StudentDB().getQuestionText(
                widget.teacherUid,
                widget.subjectName,
                widget.questionPaperName,
                widget.questionNumber),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                Map<String, dynamic> questionText = snapshot.data;
                return SingleChildScrollView(
                    child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>
                          [
                            Padding(
                              padding: const EdgeInsets.only(top:18),
                              child:questionText.containsKey('question')?Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(questionText['question'],style: TextStyle(color: Colors.white,fontSize:20,fontWeight: FontWeight.bold,fontFamily: 'OpenSans-Italic'),textAlign: TextAlign.center,),
                                SizedBox(width:15),
                                Text("("+questionText['total_marks'].toString()+"M)",style: TextStyle(color: Colors.white,fontSize:20,fontWeight: FontWeight.bold),),
                              ],
                            ) : Text('No question text added yet, please contact your Teacher',style: TextStyle(color: Colors.white),),
                          ), 
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)), color: Colors.white),
                        height: MediaQuery.of(context).size.height-145,
                        width: MediaQuery.of(context).size.width,
                        child: Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Choose Image from Gallery'),
                                IconButton(
                                  icon: Icon(Icons.insert_drive_file),
                                  onPressed: () {
                                    getImage(false);
                                  },
                                ),
                                SizedBox(height: 30.0),
                                Text('Click Image from Camera'),
                                IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    getImage(true);
                                  },
                                ),
                                _image == null
                                    ? Container()
                                    : Image.file(
                                        _image,
                                        height: 300.0,
                                        width: 300.0,
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(top:58.0),
                                  child: SizedBox(
                                    width: 200.0,
                                    height: 50.0,
                                    child: RaisedButton(
                                      color: Color(0xFF6F35A5),
                                      textColor: Colors.white,
                                        child: Text("Send Image"),
                                        shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)),
                                        onPressed: () {
                                          if (_image != null) {
                                            SendImage()
                                                .getExtractedText(_image, questionText['answer'].toString())
                                                .then((value) {
                                              print("hello $value");
                                              setState(() {
                                                _text = "Answer recordded!";
                                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Answer recorded'),));
                                                print(value);
                                              });
                                              StudentDB().addAnswer(widget.teacherUid, widget.subjectName, widget.questionPaperName, widget.questionNumber, value['text'], value['marks']);
                                            });
                                          } else {
                                            print("Error");
                                          }
                                        }),
                                  ),
                                ),
                                // Text(_text),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else
                return Container();
            }));
  }
}
