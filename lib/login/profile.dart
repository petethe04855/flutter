import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase/model/UserService.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
//รูป
import 'package:image_picker/image_picker.dart';

//firebase
import 'package:flutter_firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/login/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../model/profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? testText;
  final _formKey_reg = GlobalKey<FormState>();
  //
  late bool passwordVisibility = true;
  late bool confirm_passwordVisibility = true;

  //ตัวแปรไฟล์ อัพโหลดรููปภาพ
  File? _imageFile;
  final _picker = ImagePicker();

  Uint8List? imageList;
  String imageUrl = "";

  ///แสดงรหัสและซ่อนรหัสผ่าน
  void _toggle() {
    setState(() {
      passwordVisibility = !passwordVisibility;
      confirm_passwordVisibility = !confirm_passwordVisibility;
    });
  }

  //ฟังก์ชั่นวันที่

  void _selDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //กำหนดปีเริ่มต้นถึงปัจจุบัน
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        profileEdit.time.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  //ฟังก์ชั่นเปิดไฟล์รูป

  _selectFile(bool imageFrom) async {
    profileEdit.file = await ImagePicker().pickImage(
      source: imageFrom ? ImageSource.gallery : ImageSource.camera,
    );

    if (profileEdit.file != null) {
      setState(() {
        profileEdit.selectFileName = profileEdit.file!.name;
        print("profileEdit.file!.name ${profileEdit.file!.name}");
        //
      });
    }
  }

  //อัปโหลดรูปขึ้น FirebaseStorage
  _upLoadFile() async {
    try {
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('/' + profileEdit.file!.name);

      uploadTask = ref.putFile(File(profileEdit.file!.path));

      await uploadTask.whenComplete(() => null);

      imageUrl = await ref.getDownloadURL();

      print('UpLoaded Image URL ' + imageUrl);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  //เก็บค่า url รูปภาพ
  // void showImage(String getUrlimage) async {
  //   print("getUrlimage ${getUrlimage}");
  //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('images')
  //       .child('/' + getUrlimage);

  //   imageUrl = await ref.getDownloadURL();
  //   print("imageList ${imageList}");
  //   setState(() {});
  // }

  Future<String> getNameImage(String getUrlimage) async {
    print("getUrlimage ${getUrlimage}");
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('/' + getUrlimage);

    return await ref.getDownloadURL();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  TextEditingController first_namecontroller = TextEditingController();
  TextEditingController last_namecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController phomeNumbercontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          first_namecontroller.text = data['first_name'];
          last_namecontroller.text = data['last_name'];
          timecontroller.text = data['time'];
          addresscontroller.text = data['address'];
          //เรียกใช้ void ส่งค่า data['image']
          //showImage(data['images']);
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey_reg,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'สมัครสมาชิก',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Text(auth.currentUser!.uid),
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
                                        })
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: ElevatedButton(
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
                                                leading:
                                                    Icon(Icons.photo_library),
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
                                                leading:
                                                    Icon(Icons.photo_library),
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
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isNotEmpty && value.length > 2) {
                                      return null;
                                    } else if (value.length < 4 &&
                                        value.isNotEmpty) {
                                      return 'กรุณากรอกข้อมูลให้ครบ';
                                    } else {
                                      return 'กรุณากรอกข้อมูล';
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  controller: first_namecontroller,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'ชื่อ',
                                    hintText: 'ชื่อ',
                                    icon: Icon(Icons.person),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isNotEmpty && value.length > 2) {
                                      return null;
                                    } else if (value.length < 6 &&
                                        value.isNotEmpty) {
                                      return 'กรุณากรอกข้อมูลให้ครบ';
                                    } else {
                                      return 'กรุณากรอกข้อมูล';
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  controller: last_namecontroller,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'นามสกุล',
                                    hintText: 'นามสกุล',
                                    icon: Icon(Icons.person),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "กรุณาป้อนรหัสผ่าน"),
                                  keyboardType: TextInputType.phone,
                                  controller: profileEdit.phomeNumber,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'เบอร์โทรศัพท์',
                                    hintText: 'เบอร์โทรศัพท์',
                                    icon: Icon(Icons.phone_android),
                                  ),
                                ),
                              ),
                              Padding(
                                // const เป็นค่าคงที่ ไม่สามารถเปลี่ยนค่าได้
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "กรุณากรอกวันที่"),
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'เลือกวันเกิด',
                                    hintText: 'MM-DD-YYYY',
                                    icon: Icon(Icons.calendar_today_rounded),
                                  ),
                                  onTap: _selDatePicker,
                                  controller: timecontroller,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "กรุณากรอกที่อยู่"),
                                  keyboardType: TextInputType.streetAddress,
                                  controller: profileEdit.address,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'ที่อยู่',
                                    hintText: 'ที่อยู่',
                                    icon: Icon(Icons.add_home_sharp),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                child: ElevatedButton(
                                  onPressed: () {
                                    profileEdit.updateUser(context);
                                    //register_Confirm(context)
                                    if (!_formKey_reg.currentState!
                                        .validate()) {
                                      return;
                                    } else if (profileEdit
                                            .selectFileName.isEmpty !=
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
                              ElevatedButton(
                                onPressed: () {
                                  //profileEdit.getImage();
                                  //_upLoadFile();
                                  setState(() {});
                                },
                                child: Text("button Test"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        void register_Aut(String email, String password) async {
          CircularProgressIndicator();
          if (_formKey_reg.currentState!.validate()) {}
        }

        return Text("loading");
      },
    );
  }
}
