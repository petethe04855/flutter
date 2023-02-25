import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Page_1 extends StatefulWidget {
  const Page_1({super.key});

  @override
  State<Page_1> createState() => _Page_1State();
}

class _Page_1State extends State<Page_1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getFirebase() {
    /*FirebaseFirestore firestore = FirebaseFirestore.instance;
    //FirebaseFirestore ดึงแบบหลายตัว
    FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    //เรียกใช้ collection user
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    return FutureBuilder<DocumentSnapshot<dynamic>>(
      future: users.doc("V7KfMY1kSuAmOWV2QEvQ").get(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          print("${snapshot.data!.data()}");
          Map<String, dynamic> user = snapshot.data!.data();
          print(user.runtimeType);
          return Text("${user['name']}");
        } else {
          return Text("load....");
        }
      },
    );
  }
}
