import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart'; //Uint8List
import 'package:image_picker/image_picker.dart';

final storage = FirebaseStorage.instance;

ProfileEdit profileEdit = ProfileEdit();
final auth = FirebaseAuth.instance;

class ProfileEdit {
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
  TextEditingController role = TextEditingController();

  var rool = "Student";

  updateUser(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    var user = auth.currentUser;
    final uid = ref.doc().id;
    final docRef = ref.doc(uid);
    print("uid ${uid}");
    ref
        .doc(user!.uid)
        .update({
          'first name': fname.text,
          'last name': lname.text,
          'time': time.text,
          'phomeNumber': phomeNumber.text,
          'address': address.text,
          'images': file!.name,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  getImage(String imageURLname) async {
    final storageRef = FirebaseStorage.instance.ref();

    final islandRef = storageRef.child("images/$imageURLname");
    print("islandRef $islandRef");

    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await islandRef.getData(oneMegabyte);
      print("data ${data}");
      return data;
      // Data for "images/island.jpg" is returned, use this as needed.
    } on FirebaseException catch (e) {
      // Handle any errors.
    }
  }
}
