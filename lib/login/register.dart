import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/model/registerService.dart';
import 'package:flutter_firebase/login/symptom.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

//firebase
import 'package:flutter_firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //
  String? testText;
  final formKey = GlobalKey<FormState>();

  //
  late bool passwordVisibility = true;
  late bool confirm_passwordVisibility = true;
  final email = TextEditingController();
  final password = TextEditingController();
  late double height, width;
  bool confirmEnabled = true;

  /// Which holds the selected date
  /// Defaults to today's date.
  ///

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

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => this._imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => this._imageFile = File(pickedFile.path));
    }
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  //ตัวแปรไฟล์ อัพโหลดรููปภาพ
  File? _imageFile;
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(testText == null ? "Error" : testText!),
            ),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("สมัครสมาชิก"),
              centerTitle: true,
              backgroundColor: Color.fromARGB(99, 0, 110, 255),
              automaticallyImplyLeading: false,
              leading: BackButton(
                color: Colors.black,
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
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
                            _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  )
                                : FlutterLogo(size: 160),
                          ],
                        ),
                      ),
                      if (confirmEnabled)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size.fromHeight(560),
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          //if user click this button. user can upload image from camera
                          onPressed: () async => _pickImageFromCamera(),
                          child: Row(
                            children: [
                              Icon(Icons.photo_camera),
                              Text('From Camera'),
                              const SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          maximumSize: Size.fromHeight(560),
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          textStyle: TextStyle(fontSize: 20),
                        ),
                        //if user click this button. user can upload image from camera
                        onPressed: () async => _pickImageFromGallery(),
                        child: Row(
                          children: [
                            Icon(Icons.camera),
                            Text('From Camera'),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isNotEmpty && value.length > 2) {
                                    return null;
                                  } else if (value.length < 3 &&
                                      value.isNotEmpty) {
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
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
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
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
                                controller: registerService.email,
                                enabled: confirmEnabled,
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
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
                                controller: registerService.password,
                                enabled: confirmEnabled,
                                obscureText: passwordVisibility,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          passwordVisibility =
                                              !passwordVisibility;
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
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
                                controller: registerService.password_Confirm,
                                enabled: confirmEnabled,
                                obscureText: passwordVisibility,
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
                                        passwordVisibility
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
                              // const เป็นค่าคงที่ ไม่สามารถเปลี่ยนค่าได้
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
                                validator: RequiredValidator(
                                    errorText: "กรุณากรอกวันที่"),
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
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: TextFormField(
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                        child: ElevatedButton(
                          onPressed: () {
                            //register_Confirm(context);
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            if (confirmEnabled) {
                              confirmEnabled = false;
                              setState(() {});
                            } else {
                              register_Confirm(context);
                            }
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

//ลิ้งไปหน้าอื่นแล้วมีอันเมชั่นขยับซ้ายออก

void register_Confirm(BuildContext context) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) {
    return Symptom();
  }));
}
