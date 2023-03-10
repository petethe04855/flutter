import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/model/registerService.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey_reg = GlobalKey<FormState>();
  late bool passwordVisibility = true;
  late bool confirm_passwordVisibility = true;
  late bool confirmEnabled = true;
  late DateTime dateTime;

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

  void _selDatePicker() {
    // showCupertinoModalPopup(
    //   context: context,
    //   builder: (context) => Container(
    //     height: 250,
    //     color: Colors.white,
    //     child: Column(children: [
    //       TextButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: Text("data")),
    //       Expanded(
    //         child: CupertinoDatePicker(
    //           minimumYear: 2000,
    //           maximumYear: dateTime.year,
    //           onDateTimeChanged: (_) {},
    //           mode: CupertinoDatePickerMode.date,
    //         ),
    //       )
    //     ]),
    //   ),
    // ).then((pickedDate) {
    //   if (pickedDate != null) {
    //     registerService.time.text =
    //         DateFormat('dd MMMM yyyy').format(pickedDate);
    //   }
    // });
    // DatePicker.showSimpleDatePicker(
    //   context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(1960),
    //   lastDate: DateTime.now(),
    //   dateFormat: "dd-MMMM-yyyy",
    //   locale: DateTimePickerLocale.th,
    //   looping: true,
    // ).then((pickedDate) {
    //   if (pickedDate != null) {
    //     registerService.time.text =
    //         DateFormat('dd MMMM yyyy').format(pickedDate);
    //   }
    // });
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
        registerService.time.text = DateFormat.yMd().format(pickedDate);
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

  @override
  Widget build(BuildContext context) {
    String URLline = "http://line.me/ti/p/";
    String IDline = "";

    String url = URLline + "~" + IDline;

    print(url);
    final maskFormatter = MaskTextInputFormatter(
      mask: '+66 ###-###-####',
    );
    const sizedBoxSpace = SizedBox(height: 24);
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => () => FocusScope.of(context).requestFocus(),
          child: ListView(
            children: <Widget>[
              Form(
                  key: _formKey_reg,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(children: [
                              Text(
                                'สมัครสมาชิก',
                                style: TextStyle(fontSize: 24),
                              )
                            ]),
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
                                      : ClipOval(
                                          child: Image.file(
                                            File(registerService.file!.path),
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.fill,
                                          ),
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
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
                                                      })
                                                ],
                                              ),
                                            );
                                          });
                                    }),
                                sizedBoxSpace,
                                TextFormField(
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
                                  controller: registerService.fname,
                                  enabled: confirmEnabled,
                                  decoration: InputDecoration(
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
                                    } else if (value.length < 4 &&
                                        value.isNotEmpty) {
                                      return 'กรุณากรอกข้อมูลให้ครบ';
                                    } else {
                                      return 'กรุณากรอกข้อมูล';
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  controller: registerService.lname,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: 'นามสกุล',
                                    icon: Icon(Icons.person),
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "กรุณาป้อมอีกเมล"),
                                    EmailValidator(
                                        errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                                  ]),
                                  controller: registerService.email,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: 'Email',
                                    hintText: 'uesr@Email.com',
                                    icon: Icon(Icons.email),
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "กรุณากรอกรหัสผ่าน"),
                                  controller: registerService.password,
                                  enabled: confirmEnabled,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: passwordVisibility,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: 'รหัสผ่าน',
                                    icon: Icon(Icons.password),
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
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
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
                                  controller: registerService.password_Confirm,
                                  enabled: confirmEnabled,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: confirm_passwordVisibility,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: 'รหัสผ่าน',
                                    icon: Icon(Icons.password),
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
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "กรุณาป้อนรหัสผ่าน"),
                                  controller: registerService.phomeNumber,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [maskFormatter],
                                  enabled: confirmEnabled,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    labelText: 'เบอร์โทรศัพท์',
                                    hintText: 'เบอร์โทรศัพท์',
                                    icon: Icon(Icons.phone_android),
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "กรุณากรอกวันที่"),
                                  controller: registerService.time,
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
                                sizedBoxSpace,
                                TextFormField(
                                  controller: registerService.IDline,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: 'LineID',
                                    icon: Icon(Icons.date_range),
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  validator: RequiredValidator(
                                      errorText: "กรอกที่อยู่"),
                                  controller: registerService.address,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: 'ที่อยู่',
                                    hintText: 'ที่อยู่',
                                    icon: Icon(Icons.home),
                                    border: UnderlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                registerService.rool == "ผู้ป่วย"
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        child: _dropdown())
                                    : SizedBox(),
                                Row(
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
                                            if (registerService.rool ==
                                                "ผู้ป่วย") {}

                                            registerService
                                                    .currentItemSelected =
                                                newValueSelected!;
                                            registerService.rool =
                                                newValueSelected;
                                          });
                                        },
                                        value:
                                            registerService.currentItemSelected,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 12),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //register_Confirm(context)
                                      if (!_formKey_reg.currentState!
                                          .validate()) {
                                        return;
                                      } else if (registerService
                                              .selectFileName.isEmpty !=
                                          null) {
                                        registerService
                                            .register_signUp(context);
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
                        ],
                      ),
                    ),
                  ))
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
}
