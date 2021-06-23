import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paper_evaluation_app/main.dart';

class UserManagement {
  void storeNewUser(user, role, name, context) {
    print(user.uid);
    Firestore.instance.collection('users').document('${user.uid}').setData({
      'name': name,
      'email': user.email,
      'uid': user.uid,
      'role': role,
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/loginpage');
    }).catchError((e) {
      print(e);
    });
  }

  Future<FirebaseUser> getUser() async{
    var user;
    await FirebaseAuth.instance.currentUser().then((value) => user = value);
    return user;
    
  }

  Future<String> getUserRole(FirebaseUser user) async {
    DocumentReference userDocRef =
        Firestore.instance.collection('users').document('${user.uid}');
    String _role;
    await userDocRef.get().then((DocumentSnapshot userDoc) {
      if (userDoc.exists) {
        _role = userDoc.data['role'];
        print("In UM $_role");
      }
    }).catchError((e) {
      print(e);
    });
    return _role;
  }

  Future<FirebaseUser> signIn(email, password) async {
    var user;
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((e) {
      print(e);
    }).then((authUser) {
      user = authUser.user;
    });
    return user;
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/loginpage');
  }
}
