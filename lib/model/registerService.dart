import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/login/login_page.dart';
import 'package:flutter_firebase/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//รูป
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

RegisterService registerService = RegisterService();

class RegisterService {
  var selectFileName = "";
  XFile? file;
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password_Confirm = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController phomeNumber = TextEditingController();
  TextEditingController address = TextEditingController();

  var symptomAry = [
    'ปวดหลัง',
    'ปวดไหล่',
  ];
  var symptomAry_1 = "ปวดหลัง";
  var symptomAry_2 = "ปวดหลัง";

  var options = [
    'ผู้ป่วย',
    'หมอ',
  ];
  var currentItemSelected = "ผู้ป่วย";
  var rool = "ผู้ป่วย";

  // var patient = "ผู้ป่วย";
  // var dr = "หมอ";

  final _auth = FirebaseAuth.instance;

  void register_signUp(BuildContext context) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) => {postDetailsToFirestore(context)});
      //.catchError((e) {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showMyDialog(context);
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    print("email.text ${email.text}");
    print("password.text ${password.text}");
    print("password_Confirm.text ${password_Confirm.text}");
    // Navigator.pushReplacement(
    //     context, CupertinoPageRoute(builder: (context) => Login_page()));
  }

  postDetailsToFirestore(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');

    if (registerService.rool == "ผู้ป่วย") {
      ref.doc(user!.uid).set({
        'uid': user!.uid,
        'first name': fname.text,
        'last name': lname.text,
        'email': email.text,
        'time': time.text,
        'phomeNumber': phomeNumber.text,
        'address': address.text,
        'symptom': symptomAry_2,
        'Role': rool,
        'images': file!.name,
      });
    } else {
      ref.doc(user!.uid).set({
        'uid': user!.uid,
        'first name': fname.text,
        'last name': lname.text,
        'email': email.text,
        'time': time.text,
        'phomeNumber': phomeNumber.text,
        'address': address.text,
        'Role': rool,
        'images': file!.name,
      });
    }

    if (rool == "ผู้ป่วย") {
      print("ผู้ป่วย");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Start_Page()));
    } else {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => Login_page()));
    }
  }

  void sign_user(email, password) async {
    try {
      UserCredential auth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.--------');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.-------');
      }
    }
    print("registerService.email.text ${email}");
    print("registerService.password.text ${password.text}");
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
