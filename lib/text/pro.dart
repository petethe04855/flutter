import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/model/profile.dart';

import 'package:flutter_firebase/model/registerService.dart';
import 'package:flutter_firebase/start.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Pro_page extends StatefulWidget {
  const Pro_page({super.key});

  @override
  State<Pro_page> createState() => _Pro_pageState();
}

final auth = FirebaseAuth.instance;
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

showData() async {
  List dataUser = [];
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  var user = auth.currentUser;
  final uid = ref.doc().id;
  final docRef = ref.doc(uid);

  ref
      .doc(user!.uid)
      .get()
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user showData: $error"));

  /*FirebaseFirestore.instance
      .collection('Users')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      dataUser.add(doc['email']);
      //print(doc['email']);
      print("testdata");
    });
  });
  dataUser.forEach((val) {
    print("data User ${val[3]}");
  });
  print("dataUser ${dataUser}");*/
}

updateUser(BuildContext context) {
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  var user = auth.currentUser;
  final uid = ref.doc().id;
  final docRef = ref.doc(uid);
  ref
      .doc(user!.uid)
      .update({
        'first name': fname.text,
        'last name': lname.text,
        'time': time.text,
        'phomeNumber': phomeNumber.text,
        'address': address.text,
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user updateUser: $error"));
}

/*getImage() async {
  final storageRef = FirebaseStorage.instance.ref();

  final islandRef = storageRef.child("images/image_picker8096873113257812448");
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
}*/

/*Uint8List? imageList;
void showImage() async {
  imageList = await getImage();
  print("imageList ${imageList}");
}*/
File? _imageFile;
final _picker = ImagePicker();
XFile? file;
var selectFileName = "";

//ฟังก์ชั่นเปิดไฟล์รูป

class _Pro_pageState extends State<Pro_page> {
  Uint8List? imageList;

  _selectFile(bool imageFrom) async {
    file = await ImagePicker().pickImage(
      source: imageFrom ? ImageSource.gallery : ImageSource.camera,
    );

    if (file != null) {
      setState(() {
        selectFileName = file!.name;
      });
    }
  }

  _upLoadFile() async {
    try {
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('/' + file!.name);

      uploadTask = ref.putFile(File(file!.path));

      await uploadTask.whenComplete(() => null);
      String imageUrl = await ref.getDownloadURL();
      print('UpLoaded Image URL ' + imageUrl);
    } catch (e) {
      print(e);
    }
    showImage();
  }

  getImage() async {
    Random rand = new Random();
    int i = rand.nextInt(100000);
    final storageRef = FirebaseStorage.instance.ref();

    final islandRef = storageRef.child("images/");
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

  void showImage() async {
    imageList = await getImage();
    print("imageList ${imageList}");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    showImage();
    //showImage();
    super.initState();
  }

  File? _imageFile;

  @override
  /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Texrt"),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Text(auth.currentUser!.uid),
            Text("${auth.currentUser?.email}"),
            imageList != null
                ? Image.memory(imageList!)
                : Icon(Icons.abc_outlined),
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
                            topRight: Radius.circular(25)),
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
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'fname',
              ),
              //controller: fname,
            ),

            /*Center(
              child: imageList != null
                  ? Image.memory(imageList!)
                  : Icon(Icons.abc_outlined),
            ),*/
            ElevatedButton(
              onPressed: () {
                //updateUser(context);
                //showData();
                //Datatest(context);
              },
              child: Text("up"),
            ),
            ElevatedButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => Start_Page()));
                });
              },
              child: Text("ออกจากระบบ"),
            )
          ],
        )),
      ),
    );
  }*/

  TextEditingController firstName = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(auth.currentUser!.uid).get(),
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
          print("snapshot.data ${data}");
          firstName.text = data['first name'];

          return Scaffold(
            appBar: AppBar(
              title: Text("Show"),
            ),
            body: SafeArea(
                child: Column(
              children: [
                Text("Uid ${data['uid ']}"),
                Text("first name: ${data['first name']}"),
                Text("last name: ${data['last name']}"),
                Text("email: ${data['email']}"),
                Text("time: ${data['time']}"),
                Text("phomeNumber: ${data['phomeNumber']}"),
                Text("images: ${data['images']}"),
                Text("address: ${data['address']}"),
                Text(auth.currentUser!.uid),
                TextField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "fname",
                      hintText: ''),
                  controller: firstName,
                ),
                ElevatedButton(
                    onPressed: () {
                      //data.forEach((key, value) => print(value));
                      //data_container(data);
                      //updateUser(context);
                    },
                    child: Text("up"))
              ],
            )),
          );
        }

        return Text("loading");
      },
    );
  }
}
