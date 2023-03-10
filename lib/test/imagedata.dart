import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class imagedata extends StatefulWidget {
  const imagedata({super.key});

  @override
  State<imagedata> createState() => _imagedataState();
}

class _imagedataState extends State<imagedata> {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String imageUrl = "";
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  var imageNameData;
  XFile? file;
  var selectFileName = "";

  _selectFile(bool imageFrom) async {
    file = await ImagePicker().pickImage(
      source: imageFrom ? ImageSource.gallery : ImageSource.camera,
    );
    print("imageNameData ${file}");

    if (file != null) {
      setState(() {
        selectFileName = file!.name;
        print("file!.name ${file!.name}");
        print("selectFileName ${selectFileName}");
      });
    }
    print("imageFrom ${file}");
  }

  _upLoadFile() async {
    try {
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('test')
          .child('/' + file!.name);
      print("file!.name ${file!.name}");
      print("ref ${ref}");

      uploadTask = ref.putFile(File(file!.path));

      await uploadTask.whenComplete(() => null);

      String imageUrl = await ref.getDownloadURL();

      print('UpLoaded Image URL ' + imageUrl);
    } catch (e) {
      print(e);
    }
  }

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
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    print("email.text ${email.text}");
    print("password.text ${password.text}");
    // Navigator.pushReplacement(
    //     context, CupertinoPageRoute(builder: (context) => Login_page()));
  }

  postDetailsToFirestore(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('test');

    ref.doc(user!.uid).set({
      'email': email.text,
      'password': password.text,
      'images': file!.name,
    });
  }

  Future<String> getNameImage(String getUrlimage) async {
    print("getUrlimage ${getUrlimage}");
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('/' + getUrlimage);

    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    XFile? _imageFile;
    final key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("สมัครสมาชิก"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(99, 0, 110, 255),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(),
          child: ListView(
            children: <Widget>[
              Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'สมัครสมาชิก',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Center(
                      child: selectFileName.isEmpty
                          ? Icon(
                              Icons.image_not_supported,
                              size: 150,
                            )
                          : Image.file(
                              File(file!.path),
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                            ),
                    ),
                    ElevatedButton(
                      child: Wrap(
                        children: [
                          Icon(Icons.camera),
                          Text('รูปถ่าย'),
                        ],
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: Wrap(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text(
                                      "รูปภาพ",
                                      style: TextStyle(),
                                    ),
                                    onTap: () {
                                      _selectFile(true);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text(
                                      "กล่อง",
                                      style: TextStyle(),
                                    ),
                                    onTap: () {
                                      _selectFile(false);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    TextFormField(
                      controller: email,
                    ),
                    TextFormField(
                      controller: password,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _upLoadFile();
                          register_signUp(context);
                        },
                        child: Text("add"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text('A dialog is a type of modal window that\n'
              'appears in front of app content to\n'
              'provide critical information, or prompt\n'
              'for a decision to be made.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
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
