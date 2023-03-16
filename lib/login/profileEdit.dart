import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/model/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey_Edit = GlobalKey<FormState>();
  late bool passwordVisibility = true;
  late bool confirm_passwordVisibility = true;
  late bool confirmEnabled = true;
  late DateTime dateTime;

  Uint8List? imageList;
  String imageUrl = "";

  _selectFile(bool imageFrom) async {
    profileEditMode.file = await ImagePicker().pickImage(
      source: imageFrom ? ImageSource.gallery : ImageSource.camera,
    );

    if (profileEditMode.file != null) {
      setState(() {
        profileEditMode.selectFileName = profileEditMode.file!.name;
      });
    }
  }

  //เก็บค่า url รูปภาพ
  void showImage(String getUrlimage) async {
    print("getUrlimage ${getUrlimage}");
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('/' + getUrlimage);

    imageUrl = await ref.getDownloadURL();
    print("imageList ${imageList}");
    setState(() {});
  }

  Future<String> getNameImage(String getUrlimage) async {
    print("getUrlimage ${getUrlimage}");
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('/' + getUrlimage);

    return await ref.getDownloadURL();
  }

  void _selDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //กำหนดปีเริ่มต้นถึงปัจจุบัน
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        profileEditMode.time.text = DateFormat.yMd().format(pickedDate);
        print("pickedDate ${pickedDate}");
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    dateTime = DateTime.now();
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(
      mask: '+66 ###-###-####',
    );
    const sizedBoxSpace = SizedBox(height: 24);
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
            profileEditMode.fname.text = data['first_name'];
            profileEditMode.lname.text = data['last_name'];
            profileEditMode.time.text = data['time'];
            profileEditMode.phomeNumber.text = data['phomeNumber'];
            profileEditMode.address.text = data['address'];
            String dataImage = data['images'];
            return Scaffold(
              body: SafeArea(
                child: GestureDetector(
                  onTap: () => () => FocusScope.of(context).requestFocus(),
                  child: ListView(
                    children: <Widget>[
                      Form(
                        key: _formKey_Edit,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'แก้ไข',
                                        style: TextStyle(fontSize: 24),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      FutureBuilder(
                                        future: getNameImage(data['images']),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshotUrl) {
                                          print(
                                              "snapshotUrl ${snapshotUrl.data}");
                                          if (snapshotUrl.hasData) {
                                            String dataImage = snapshotUrl.data;
                                            print("imageUrl ${imageUrl}");
                                            print("dataImage ${dataImage}");
                                            return Center(
                                                child: imageUrl != ''
                                                    ? Image.network(
                                                        imageUrl,
                                                        height: 250,
                                                        width: 250,
                                                      )
                                                    : Image.network(
                                                        dataImage,
                                                        height: 250,
                                                        width: 250,
                                                      ));
                                          } else {
                                            return Text("loading...");
                                          }
                                        },
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
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          topRight:
                                                              Radius.circular(
                                                                  25)),
                                                ),
                                                child: Wrap(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.photo_library),
                                                      title: Text(
                                                        "รูปภาพ",
                                                        style: TextStyle(),
                                                      ),
                                                      onTap: () {
                                                        _selectFile(true);

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.photo_library),
                                                      title: Text(
                                                        "กล่อง",
                                                        style: TextStyle(),
                                                      ),
                                                      onTap: () {
                                                        _selectFile(false);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                        child: ElevatedButton(
                          onPressed: () {
                            profileEditMode.updateUser(context);
                            //register_Confirm(context)
                            if (!_formKey_Edit.currentState!.validate()) {
                              return;
                            } else if (profileEditMode.selectFileName.isEmpty !=
                                null) {
                            } else {
                              setState(() {});
                            }
                          },
                          child: const Text(
                            'ลงทะเบียน',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Text("loading");
        });
  }
}
