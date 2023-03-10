import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/dr/test.dart';

class Wait_Page extends StatefulWidget {
  const Wait_Page({super.key});

  @override
  State<Wait_Page> createState() => _Wait_PageState();
}

class _Wait_PageState extends State<Wait_Page> {
  CollectionReference userDr = FirebaseFirestore.instance.collection('Users');
  final _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userDr.doc(_auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['Status'] == 0) {
            return Scaffold(
              body: SafeArea(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(),
                  child: ListView(
                    children: <Widget>[
                      Text("อยู่ระหว่างตรวจสอบข้อมูล"),
                    ],
                  ),
                ),
              ),
            );
          } else if (data['Status'] == 1) {
            return Test_Page();
          }
        }
        return Text("loading");
      },
    );
  }
}
