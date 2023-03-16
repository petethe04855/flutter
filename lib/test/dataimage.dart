import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/admin/updata.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../model/profile.dart';

class dataImage extends StatefulWidget {
  const dataImage({super.key});

  @override
  State<dataImage> createState() => _dataImageState();
}

class _dataImageState extends State<dataImage> {
  // String imageUrl = "";
  // PlatformFile? pickedFile;
  // File? selectedImage;
  // String userId = '';
  // final _auth = FirebaseAuth.instance;
  // final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // _selectFile(bool imageFrom) async {
  //   profileEditMode.file = await ImagePicker().pickImage(
  //     source: imageFrom ? ImageSource.gallery : ImageSource.camera,
  //   );

  //   if (profileEditMode.file != null) {
  //     setState(() {
  //       profileEditMode.selectFileName = profileEditMode.file!.name;
  //     });
  //   }
  // }

  // Future selectFile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result == null) return;

  //   setState(() {
  //     pickedFile = result.files.first;
  //   });
  // }

  // _selectFile(bool imageFrom) async {
  //   profileEditMode.file = await ImagePicker().pickImage(
  //     source: imageFrom ? ImageSource.gallery : ImageSource.camera,
  //   );

  //   if (profileEditMode.file != null) {
  //     setState(() {
  //       profileEditMode.selectFileName = profileEditMode.file!.name;
  //       print("profileEditMode.file!.name ${profileEditMode.file!.name}");
  //       //
  //     });
  //   }
  // }

  // Future<void> uploadImageToFirebase(String userId) async {
  //   if (selectedImage != null) {
  //     String fileName = '$userId.jpg';
  //     Reference reference =
  //         FirebaseStorage.instance.ref().child('images/$fileName');
  //     UploadTask uploadTask = reference.putFile(selectedImage!);
  //     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //     setState(() {
  //       selectedImage = null;
  //       imageUrl = downloadURL;
  //     });
  //     updateUserImage(userId, downloadURL);
  //   }
  // }

  // void updateUserImage(String userId, String imageUrl) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //   users.doc(userId).update({'images': imageUrl});
  //   setState(() {});
  // }

  // _selectFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //   );

  //   if (result != null) {
  //     setState(() {
  //       selectedImage = File(result.files.single.path!);
  //     });
  //   }
  // }

  // updata() async {
  //   uploadImageToFirebase(userId);
  // }

  // Future<void> getOldImageUrl(String userId) async {
  //   String fileName = '$userId.jpg';
  //   Reference reference =
  //       FirebaseStorage.instance.ref().child('images/$fileName');
  //   imageUrl = await reference.getDownloadURL();
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   userId = _auth.currentUser!.uid;
  // }
  String imageUrl = "";
  File? selectedImage;
  String userId = '';
  final _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  void updateUserImage(String userId, String imageUrl) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    users.doc(userId).update({'images': imageUrl});
    setState(() {});
  }

  Future<void> uploadImageToFirebase(String userId) async {
    if (selectedImage != null) {
      String fileName = '$userId.jpg';
      Reference reference =
          FirebaseStorage.instance.ref().child('images').child('/' + fileName);
      UploadTask uploadTask = reference.putFile(selectedImage!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        selectedImage = null;
        imageUrl = downloadURL;
      });
      updateUserImage(userId, downloadURL);
    }
  }

  updata() async {
    uploadImageToFirebase(userId);
  }

  Future<void> getOldImageUrl(String userId) async {
    String fileName = '$userId.jpg';
    Reference reference =
        FirebaseStorage.instance.ref().child('images').child('/' + fileName);
    try {
      imageUrl = await reference.getDownloadURL();
    } catch (e) {
      imageUrl = '';
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
    getOldImageUrl(userId);
  }

  @override
  Widget build(BuildContext context) {
    print(_auth.currentUser!.uid);
    print("userId : " + userId);
    print("imageUrl : " + imageUrl);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              child: selectedImage != null
                  ? Image.file(
                      selectedImage!,
                    )
                  : (imageUrl.isNotEmpty
                      ? Image.network(imageUrl)
                      : Container()),
            ),
            ElevatedButton(
              onPressed: () {
                _selectFile();
              },
              child: Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () {
                updata();
              },
              child: Text("Upload"),
            ),
          ],
        ),
      ),
    );
    /*return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              child: profileEditMode.selectFileName.isEmpty
                  ? Image.network(imageUrl)
                  : Image.file(
                      File(profileEditMode.file!.path),
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                _selectFile();
              },
              child: Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () {
                updata();
              },
              child: Text("Upload"),
            ),
          ],
        ),
      ),
    );*/
  }
}
