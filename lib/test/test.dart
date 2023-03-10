import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/text/pro.dart';

AddData addData = AddData();

class AddData {
  final _auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  addData(BuildContext context) async {
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
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  postDetailsToFirestore(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('test');

    ref.doc(user!.uid).set({
      'uid': user!.uid,
      'email': email.text,
      'images': file!.name,
    });
    print("email ${email}");
    print("password ${password}");
  }
}
