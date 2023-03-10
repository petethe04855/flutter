import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
//รูป
import 'package:image_picker/image_picker.dart';
import '../model/registerService.dart';

//firebase
import 'package:flutter_firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/login/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Register_test extends StatefulWidget {
  const Register_test({super.key});

  @override
  State<Register_test> createState() => _Register_testState();
}

class _Register_testState extends State<Register_test> {
  String? testText;
  final _formKey_reg = GlobalKey<FormState>();
  //
  late bool passwordVisibility = true;
  late bool confirm_passwordVisibility = true;

  late double height, width;
  bool confirmEnabled = true;
  String errorMessage = "eeeeeeeeeeeeee";

  //ตัวแปรไฟล์ อัพโหลดรููปภาพ
  File? _imageFile;
  final _picker = ImagePicker();

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
        registerService.time.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  //ฟังก์ชั่นเปิดไฟล์รูป

  _selectFile(bool imageFrom) async {
    registerService.file = await ImagePicker().pickImage(
      source: imageFrom ? ImageSource.gallery : ImageSource.camera,
    );

    if (registerService.file != null) {
      setState(() {
        registerService.selectFileName = registerService.file!.name;
      });
    }
  }

  _upLoadFile() async {
    try {
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('/' + registerService.file!.name);

      uploadTask = ref.putFile(File(registerService.file!.path));

      await uploadTask.whenComplete(() => null);

      String imageUrl = await ref.getDownloadURL();

      print('UpLoaded Image URL ' + imageUrl);
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
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
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Center(
                                child: registerService.selectFileName.isEmpty
                                    ? Icon(
                                        Icons.image_not_supported,
                                        size: 150,
                                      )
                                    : Image.file(
                                        File(registerService.file!.path),
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.fill,
                                      ),
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
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: TextFormField(
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
                            controller: registerService.fname,
                            enabled: confirmEnabled,
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
                              } else if (value.length < 6 && value.isNotEmpty) {
                                return 'กรุณากรอกข้อมูลให้ครบ';
                              } else {
                                return 'กรุณากรอกข้อมูล';
                              }
                            },
                            keyboardType: TextInputType.name,
                            controller: registerService.lname,
                            enabled: confirmEnabled,
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
                            validator: MultiValidator([
                              RequiredValidator(errorText: "กรุณาป้อมอีกเมล"),
                              EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                            ]),
                            controller: registerService.email,
                            enabled: confirmEnabled,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'uesr@Email.com',
                              icon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        Padding(
                          // const เป็นค่าคงที่ ไม่สามารถเปลี่ยนค่าได้
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"),
                            controller: registerService.password,
                            enabled: confirmEnabled,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: passwordVisibility,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisibility = !passwordVisibility;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisibility
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  )),
                              labelText: 'Password',
                              hintText: 'Password',
                              icon: Icon(Icons.lock),
                            ),
                          ),
                        ),
                        Padding(
                          // const เป็นค่าคงที่ ไม่สามารถเปลี่ยนค่าได้
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "กรุณากรอกรหัสผ่าน";
                              } else if (registerService.password.text !=
                                  registerService.password_Confirm.text) {
                                return "รหัสไม่ตรงกัน";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.visiblePassword,
                            controller: registerService.password_Confirm,
                            enabled: confirmEnabled,
                            obscureText: confirm_passwordVisibility,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      confirm_passwordVisibility =
                                          !confirm_passwordVisibility;
                                    });
                                  },
                                  icon: Icon(
                                    confirm_passwordVisibility
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  )),
                              labelText: 'Confirm password',
                              hintText: 'Password',
                              icon: Icon(Icons.lock),
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
                            controller: registerService.phomeNumber,
                            enabled: confirmEnabled,
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
                            validator:
                                RequiredValidator(errorText: "กรุณากรอกวันที่"),
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'เลือกวันเกิด',
                              hintText: 'MM-DD-YYYY',
                              icon: Icon(Icons.calendar_today_rounded),
                            ),
                            onTap: _selDatePicker,
                            controller: registerService.time,
                            enabled: confirmEnabled,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณากรอกที่อยู่"),
                            keyboardType: TextInputType.streetAddress,
                            controller: registerService.address,
                            enabled: confirmEnabled,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'ที่อยู่',
                              hintText: 'ที่อยู่',
                              icon: Icon(Icons.add_home_sharp),
                            ),
                          ),
                        ),
                        registerService.rool == "ผู้ป่วย"
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: _dropdown())
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "เลือก : ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: DropdownButton<String>(
                                  items: registerService.options
                                      .map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (newValueSelected) {
                                    setState(() {
                                      if (registerService.rool == "ผู้ป่วย") {}

                                      registerService.currentItemSelected =
                                          newValueSelected!;
                                      registerService.rool = newValueSelected;
                                    });
                                  },
                                  value: registerService.currentItemSelected,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: ElevatedButton(
                            onPressed: () {
                              //register_Confirm(context)
                              if (!_formKey_reg.currentState!.validate()) {
                                return;
                              } else if (registerService
                                      .selectFileName.isEmpty !=
                                  null) {
                                _upLoadFile();
                                registerService.register_signUp(context);
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  _dropdown() {
    return DropdownButton<String>(
      items: registerService.symptomAry.map((String dropDownItem) {
        return DropdownMenuItem<String>(
          value: dropDownItem,
          child: Text(dropDownItem),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          registerService.symptomAry_1 = value!;
          registerService.symptomAry_2 = value;
        });
      },
      value: registerService.symptomAry_1,
    );
  }

  /*_dropdownTest(BuildContext context) {
    return DropdownButton<String>(
      items: registerService.symptomAry.map((String dropDownItem) {
        return DropdownMenuItem<String>(
          value: dropDownItem,
          child: Text(dropDownItem),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          registerService.a1 = value!;
          registerService.b2 = value;
        });
      },
      value: registerService.a1,
    );
  }*/

  void register_Aut(String email, String password) async {
    CircularProgressIndicator();
    if (_formKey_reg.currentState!.validate()) {}
  }
}
