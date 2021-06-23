import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:paper_evaluation_app/teacher/question_paper/load_csv.dart';
import 'package:paper_evaluation_app/teacher/question_paper/question_list_view.dart';
import 'package:paper_evaluation_app/teacher/question_paper/question_paper_detail_screen.dart';
import '../authentication/user_management.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class TeacherDB {
  Future<void> addSubject(
      String name, BuildContext context, var scaffoldKey) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference subjectsCollection = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects');
    await subjectsCollection.document(name).setData({}).then((value) {
      print("Subject added successfully");
      Navigator.of(context).pop();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Subject Added"),
      ));
    }).catchError((e) {
      print("Found error in teacher_db on adding subject\n $e");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Error Adding Subject"),
      ));
    });
  }

  Future<List<String>> getSubjects() async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference subjectsCollection = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects');
    QuerySnapshot qs = await subjectsCollection.getDocuments();
    List<String> subjectList = [];
    qs.documents.forEach((element) {
      subjectList.add(element.documentID);
      print(element.documentID);
    });
    return subjectList;
  }

  Future<void> addQuestionPaper(String name, String subjectName,
      BuildContext context, var scaffoldKey) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference subjectsCollection = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers');
    await subjectsCollection
        .document(name)
        .setData({'no_of_questions': 0}).then((value) {
      print("Question Paper added successfully");
      Navigator.of(context).pop();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Question Paper added"),
      ));
    }).catchError((e) {
      print("Found error in teacher_db on adding Question Paper\n $e");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Error Adding Question Paper"),
      ));
    });
  }

  Future<List<String>> getQuestionPapers(String subjectName) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference subjectsCollection = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers');
    QuerySnapshot qs = await subjectsCollection.getDocuments();
    List<String> questionPapertList = [];
    qs.documents.forEach((element) {
      questionPapertList.add(element.documentID);
      print(element.documentID);
    });
    return questionPapertList;
  }

  Future<List<String>> getQuestions(
      String subjectName, String questionPaperName) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference questionsCollection = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection("questions");
    QuerySnapshot qs = await questionsCollection.getDocuments();
    List<String> questionList = [];
    qs.documents.forEach((element) {
      questionList.add(element.documentID);
      print(element.documentID);
    });
    return questionList;
  }

  Future<void> addQuestion(String subjectName, String questionPaperName,
      BuildContext context, var scaffoldKey) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    DocumentReference questionsDocument = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName);

    await questionsDocument
        .updateData({'no_of_questions': FieldValue.increment(1)}).then((_) {
      print("No of questions updated sucessfully");
    }).catchError((e) {
      print(
          "Found error in teacher_db on increasing Question Paper count\n $e");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Error Adding Question Paper"),
      ));
    });

    var no_of_questions;
    await questionsDocument
        .get()
        .then((value) => no_of_questions = value['no_of_questions']);
    print(no_of_questions);

    await questionsDocument
        .collection('questions')
        .document("Q$no_of_questions")
        .setData({}).then((value) {
      print("added new question");
      // Navigator.of(context).pushReplacement(context,MaterialPageRoute(builder: (context) => QuestionListView(subjectName, questionPaperName)));
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => QuestionPaperDetailScreen(subjectName, questionPaperName)));
      // Navigator.of(context).pop();
      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => QuestionPaperDetailScreen(subjectName, questionPaperName)));
    }).catchError((e) {
      print("error adding question" + e);
    });
  }

  Future<void> addQuestionText(
      String subjectName,
      String questionPaperName,
      String questionNumber,
      String questionText,
      BuildContext context,
      var scaffoldKey) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    DocumentReference currQuestionDocument = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('questions')
        .document(questionNumber);
    await currQuestionDocument
        .setData({'question': questionText}).then((value) {
      print("Question added successfully");
      Navigator.of(context).pop();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Question Text Added"),
      ));
    }).catchError((e) {
      print("Found error in teacher_db on adding question text\n $e");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Error Adding Question Text"),
      ));
    });
  }

  Future<void> addKeyPhrase(
      String subjectName,
      String questionPaperName,
      String questionNumber,
      String keyPhrase,
      double marks,
      BuildContext context,
      var scaffoldKey) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    DocumentReference currQuestionDocument = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('questions')
        .document(questionNumber);

    Map<String, dynamic> documentData;

    await currQuestionDocument.get().then((value) => documentData = value.data);

    if (documentData.containsKey('answer')) {
      print(documentData);
      Map<dynamic, dynamic> answerMap = documentData['answer'];
      answerMap["\"$keyPhrase\""] = marks;
      await currQuestionDocument.updateData({
        'answer': answerMap,
        'total_marks': FieldValue.increment(marks)
      }).then((value) {
        print("Keyphrase added successfully in existing case");
        Navigator.of(context).pop();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Key Phrase Added"),
        ));
      }).catchError((e) {
        print("Found error in teacher_db on adding key phrase\n $e");
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Error Adding Key Phrase"),
        ));
      });
    } else {
      await currQuestionDocument.updateData({
        'answer': {"\"$keyPhrase\"": marks},
        'total_marks': marks
      }).then((value) {
        print("Keyphrase added successfully in non existing case");
        Navigator.of(context).pop();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Key Phrase Added"),
        ));
      }).catchError((e) {
        print("Found error in teacher_db on adding key phrase\n $e");
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Error Adding Key Phrase"),
        ));
      });
    }

    // await currQuestionDocument.setData({'question': questionText}).then((value) {
    //   print("Question added successfully");
    //   Navigator.of(context).pop();
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text("Question Text Added"),
    //   ));
    // }).catchError((e) {
    //   print("Found error in teacher_db on adding question text\n $e");
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text("Error Adding Question Text"),
    //   ));
    // });
  }

  Future<Map<String, dynamic>> getQuestionContent(String subjectName,
      String questionPaperName, String questionNumber) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    DocumentReference currQuestionDocument = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('questions')
        .document(questionNumber);

    Map<String, dynamic> questionContent;
    await currQuestionDocument
        .get()
        .then((value) => questionContent = value.data)
        .catchError((e) {
      print("Error getting que content $e");
    });
    print(questionContent);
    return questionContent;
  }


  Future<void> exportExcel(context, String subjectName, String questionPaperName) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference studentCollections = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('answers');

    QuerySnapshot qs = await studentCollections.getDocuments();
    List<String> studentList = [];
    List<double> studentMarks = [];
    qs.documents.forEach((element) {
      studentList.add(element.documentID);
      studentMarks.add(element.data['total_marks']);
      print(element.documentID);
    });

    CollectionReference userCollections = Firestore.instance
        .collection('users');
    
    QuerySnapshot qs1 = await userCollections.getDocuments();
    List<String> studentNames = [];
    qs1.documents.forEach((element) {
      if (studentList.contains(element.documentID)) {
        studentNames.add(element.data['name']);
      }
    });

    List<List<dynamic>> csvData = [
      ['Name', 'Marks'],
      // ['Yash', 20],
      // ['Sarika', 16],
      // data
      
    ];

    for(int i=0; i<studentList.length; i++){
      csvData.add([studentNames[i],studentMarks[i].toString()]);
    }

    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getExternalStorageDirectory()).path;
    final String path = '$dir/$subjectName-$questionPaperName.csv';
    print(path);
    // create file
    final File file = File(path);
    // Save csv string using default configuration
    // , as field separator
    // " as text delimiter and
    // \r\n as eol.
    await file.writeAsString(csv);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoadAndViewCsvPage(path: path),
      ),
    );
  }

}

