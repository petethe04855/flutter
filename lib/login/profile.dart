import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../model/profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? testText;
  final _formKey_Edit = GlobalKey<FormState>();
  //
  late bool passwordVisibility = true;
  late bool confirm_passwordVisibility = true;

  //ตัวแปรไฟล์ อัพโหลดรููปภาพ
  String imageUrl = "";
  File? selectedImage;
  String userId = '';
  late DateTime dateTime;

  Uint8List? imageList;

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
        profileEditMode.time.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  //ฟังก์ชั่นเปิดไฟล์รูป

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

  // //อัปโหลดรูปขึ้น FirebaseStorage
  // _upLoadFile() async {
  //   try {
  //     firebase_storage.UploadTask uploadTask;

  //     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('images')
  //         .child('/' + profileEditMode.file!.name);

  //     uploadTask = ref.putFile(File(profileEditMode.file!.path));

  //     await uploadTask.whenComplete(() => null);

  //     imageUrl = await ref.getDownloadURL();

  //     print('UpLoaded Image URL ' + imageUrl);
  //     setState(() {});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //เก็บค่า url รูปภาพ
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

  // Future<String> getNameImage(String getUrlimage) async {
  //   print("getUrlimage ${getUrlimage}");
  //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('images')
  //       .child('/' + getUrlimage);

  //   return await ref.getDownloadURL();
  // }

  // void initState() {
  //   // TODO: implement initState
  //   dateTime = DateTime.now();
  //   super.initState();
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

  final ImagePicker _picker = ImagePicker();

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

  final _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(
      mask: '+66 ###-###-####',
    );
    const sizedBoxSpace = SizedBox(height: 24);
    print("selectedImage : " + imageUrl);

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
                  key: _formKey_Edit,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'แก้ไขโปรไฟล์',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                child: selectedImage != null
                                    ? Image.file(
                                        selectedImage!,
                                      )
                                    : (imageUrl.isNotEmpty
                                        ? Image.network(imageUrl)
                                        : Container()),
                              ),
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
                              _selectFile();
                            },
                          ),
                        ),
                        sizedBoxSpace,
                        TextFormField(
                          validator: (value) {
                            if (value!.isNotEmpty && value.length > 2) {
                              return null;
                            } else if (value.length < 4 && value.isNotEmpty) {
                              return 'กรุณากรอกข้อมูลให้ครบ';
                            } else {
                              return 'กรุณากรอกข้อมูล';
                            }
                          },
                          keyboardType: TextInputType.name,
                          controller: profileEditMode.fname,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'ชื่อ',
                            icon: Icon(Icons.person),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        sizedBoxSpace,
                        TextFormField(
                          validator: (value) {
                            if (value!.isNotEmpty && value.length > 2) {
                              return null;
                            } else if (value.length < 6 && value.isNotEmpty) {
                              return 'กรุณากรอกข้อมูลให้ครบ';
                            } else {
                              return 'กรุณากรอกข้อมูล';
                            }
                          },
                          keyboardType: TextInputType.name,
                          controller: profileEditMode.lname,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'นามสกุล',
                            hintText: 'นามสกุล',
                            icon: Icon(Icons.person),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        sizedBoxSpace,
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "เบอร์โทรศัพท์"),
                          keyboardType: TextInputType.phone,
                          controller: profileEditMode.phomeNumber,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            labelText: 'เบอร์โทรศัพท์',
                            hintText: 'เบอร์โทรศัพท์',
                            icon: Icon(Icons.phone_android),
                          ),
                        ),
                        // const เป็นค่าคงที่ ไม่สามารถเปลี่ยนค่าได้
                        sizedBoxSpace,
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "กรุณากรอกวันที่"),
                          controller: profileEditMode.time,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'วันเกิด',
                            hintText: 'วันเกิด',
                            icon: Icon(Icons.insert_drive_file),
                            border: UnderlineInputBorder(),
                            enabled: false,
                          ),
                        ),
                        sizedBoxSpace,
                        ElevatedButton(
                          onPressed: () async {
                            _selDatePicker();
                          },
                          child: Text('date'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณากรอกที่อยู่"),
                            keyboardType: TextInputType.streetAddress,
                            controller: profileEditMode.address,
                            decoration: const InputDecoration(
                              filled: true,
                              border: UnderlineInputBorder(),
                              labelText: 'ที่อยู่',
                              hintText: 'ที่อยู่',
                              icon: Icon(Icons.add_home_sharp),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: ElevatedButton(
                            onPressed: () {
                              profileEditMode.updateUser(context);
                              updata();
                              //register_Confirm(context)
                              if (!_formKey_Edit.currentState!.validate()) {
                                return;
                              } else if (profileEditMode
                                      .selectFileName.isEmpty !=
                                  null) {
                              } else {
                                setState(() {
                                  
                                });
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
