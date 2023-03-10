import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

UpdataDR updataDR = UpdataDR();

class UpdataDR {
  var status;

  updateUsersStatus(BuildContext context, dataUid) {
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    dataUid['uid'];
    final uid = ref.doc().id;
    final docRef = ref.doc(uid);
    print("uid ${dataUid}");
    ref
        .doc(dataUid['uid'])
        .update({
          'Status': status = 1,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
