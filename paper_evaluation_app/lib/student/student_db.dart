import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentDB {
  Future<List<Map<String, String>>> getTeachers() async {
    // FirebaseUser user;
    // await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference subjectsCollection =
        Firestore.instance.collection('users');
    QuerySnapshot users = await subjectsCollection.getDocuments();
    List<Map<String, String>> teacherList = [];
    users.documents.forEach((element) {
      Map<String, dynamic> userDocument = element.data;
      if (userDocument['role'] == 'Teacher') {
        teacherList
            .add({'name': userDocument['name'], 'uid': userDocument['uid']});
      }
      // teacherList.add(element.data());
      // print(element.documentID);
    });
    print(teacherList);
    return teacherList;
  }

  Future<List<Map<String, String>>> getAttemptedPapers() async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference questionCollection = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('attempted_papers');
    QuerySnapshot attemptedPapers = await questionCollection.getDocuments();
    List<Map<String, String>> attemptedPapersLists = [];
    attemptedPapers.documents.forEach((element) {
      attemptedPapersLists
          .add({'name': element.documentID, 'path': element['path']});
      print(element.documentID);
      print(element['path']);
    });
    return attemptedPapersLists;
  }

  Future<List<String>> getSubjects(String uid) async {
    // FirebaseUser user;
    // await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference subjectsCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('subjects');
    QuerySnapshot subjects = await subjectsCollection.getDocuments();
    List<String> subjectList = [];
    subjects.documents.forEach((element) {
      subjectList.add(element.documentID);
      print(element.documentID);
    });
    return subjectList;
  }

  Future<List<String>> getQuestionPapers(String uid, String subjectName) async {
    // FirebaseUser user;
    // await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference questionPapersCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers');
    QuerySnapshot questionPapers =
        await questionPapersCollection.getDocuments();
    List<String> questionPapersList = [];
    questionPapers.documents.forEach((element) {
      questionPapersList.add(element.documentID);
      print(element.documentID);
    });
    return questionPapersList;
  }

  Future<Map<String, dynamic>> getAttemptedPaperQuestions(String path) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    DocumentReference answerDocument =
        Firestore.instance.document(path + '/answers/${user.uid}');
    Map<String, dynamic> questionsLists;

    await answerDocument.get().then((doc) {
      questionsLists = doc.data;
    });


    print(questionsLists);
    return questionsLists;
  }

  Future<List<Map<String, bool>>> getQuestions(
      String uid, String subjectName, String questionPaperName) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference questionsCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('questions');

    DocumentReference answersDocument = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('answers')
        .document(user.uid);

    // Map<String,Map<String,dynamic>> answers;
    Map<String, dynamic> answers;
    await answersDocument.get().then((doc) {
      answers = doc.data;
    });
    print("answers " + answers.toString());
    QuerySnapshot questions = await questionsCollection.getDocuments();
    List<Map<String, bool>> questionsList = [];
    questions.documents.forEach((element) {
      if (answers != null) {
        if (answers.containsKey(element.documentID)) {
          questionsList.add(
              {element.documentID: true});
          print(element.documentID);
        } else {
          questionsList.add({element.documentID: false});
          print(element.documentID);
        }
      } else {
        print("in else");
        questionsList.add({element.documentID: false});
        print(element.documentID);
      }
    });

    if (answers != null) {
      if (answers.containsKey('finished_attempt')) {
        questionsList.add({'finished_attempt': answers['finished_attempt']});
      } else {
        questionsList.add({'finished_attempt': false});
      }
    } else {
      questionsList.add({'finished_attempt': false});
    }

    print("question list" + questionsList.toString());

    return questionsList;
  }

  Future<Map<String, dynamic>> getQuestionText(String uid, String subjectName,
      String questionPaperName, String questionNumber) async {
    // FirebaseUser user;
    // await FirebaseAuth.instance.currentUser().then((value) => user = value);
    DocumentReference questionDocument = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('questions')
        .document(questionNumber);

    Map<String, dynamic> questionText;

    await questionDocument.get().then((doc) {
      // questionText = {'question' : doc.data['question'], 'total_marks':  doc.data['total_marks'].toString(), 'answer': doc.data['answer']};
      questionText = doc.data;
      print(questionText);
    }).catchError((e) {
      print("Error getting question text $e");
    });
    print(questionText);
    return questionText;
  }

  Future<void> addAnswer(
      String uid,
      String subjectName,
      String questionPaperName,
      String questionNumber,
      String text,
      String marks) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference studentAnswerCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('answers');

    QuerySnapshot students = await studentAnswerCollection.getDocuments();
    bool exists = false;
    students.documents.forEach((element) {
      if (element.documentID == user.uid) exists = true;
    });

    if (!exists) {
      studentAnswerCollection
          .document(user.uid)
          .setData({})
          .then((value) => null)
          .catchError((e) {
            print("Error creating a new doc $e");
          });
    }

    studentAnswerCollection
        .document(user.uid)
        .updateData({
          questionNumber: {text: double.parse(marks), 'submitted': true},
          'total_marks': FieldValue.increment(double.parse(marks)),
          'finished_attempt': false
        })
        .then((value) => print("added answer to db"))
        .catchError((e) {
          print("Error on adding answer to db $e");
        });
  }

  Future<void> finishAttempt(
      String uid, String subjectName, String questionPaperName) async {
    FirebaseUser user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    CollectionReference studentAnswerCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('subjects')
        .document(subjectName)
        .collection('question_papers')
        .document(questionPaperName)
        .collection('answers');

    QuerySnapshot students = await studentAnswerCollection.getDocuments();
    bool exists = false;
    students.documents.forEach((element) {
      if (element.documentID == user.uid) exists = true;
    });

    if (!exists) {
      studentAnswerCollection
          .document(user.uid)
          .setData({})
          .then((value) => null)
          .catchError((e) {
            print("Error creating a new doc $e");
          });
    }

    studentAnswerCollection
        .document(user.uid)
        .updateData({'finished_attempt': true})
        .then((value) => print("finished attempt"))
        .catchError((e) {
          print("Error finishing attempt $e");
        });

    CollectionReference attemptedPapers = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('attempted_papers');

    attemptedPapers
        .document('$subjectName $questionPaperName')
        .setData({
          'path':
              '/users/$uid/subjects/$subjectName/question_papers/$questionPaperName'
        })
        .then((value) => print("added path to attempted papers"))
        .catchError((e) {
          print("error adding path to attempted papers $e");
        });
  }
}
