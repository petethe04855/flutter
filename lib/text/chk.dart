import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/login/check_account.dart';
import 'package:flutter_firebase/model/registerService.dart';
import 'package:flutter_firebase/text/pro.dart';

class Chk_page extends StatefulWidget {
  const Chk_page({super.key});

  @override
  State<Chk_page> createState() => _Chk_pageState();
}

UserAndEmali userAndEmali = UserAndEmali();

class UserAndEmali {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
}

class _Chk_pageState extends State<Chk_page> {
  FirebaseAuth auth = FirebaseAuth.instance;

  var gg = "sssss";
  String aa = "sssss";

  var currentUser;

  /*void show_userAndPassword(BuildContext context) async {
    auth.createUserWithEmailAndPassword(
        email: email.text, password: password.text);
    if (currentUser != null) {
      // ถ้ามีข้อมูล
      _id = currentUser.uid; // เอาค่ามาเก็บในัวแร เพื่อใช้แสดง
      _email = currentUser.email ?? '';
      print(currentUser); // แสดงรายละเอียดข้อมูลของผู้ใช้ทั้งหมดว่ามีอะไรบ้าง
    }
  }*/

  void check_uid(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email:
                  "sap111@gmail.com", //userAndEmali.email.text,//userAndEmali.password.text
              password: "123456")
          .then((value) {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => Pro_page()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.--------');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.-------');
      }
    }

    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(
    //           email: userAndEmali.email.text,
    //           password: userAndEmali.password.text);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //   }

    // }
    //Prompt the user to enter their email and password
    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(
    //           email: registerService.email.text,
    //           password: registerService.password.text);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     _showMyDialog(context);
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }
    // var currentUser = FirebaseAuth.instance.currentUser;

    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     print(user.uid);
    //   }
    // });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test Email Auth"),
        ),
        body: SafeArea(
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "ชื่อผู้ใช้",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: userAndEmali.email,
                  ),
                  TextField(
                    controller: userAndEmali.password,
                  ),
                  Text("${check_uid.toString()}"),
                  Text(""),
                  ElevatedButton(
                      onPressed: () {
                        check_uid(userAndEmali.email, userAndEmali.password);
                      },
                      child: Text("Text")),
                ],
              ),
            ),
          ),
        ));
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
