import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/login/symptom.dart';
import 'package:flutter_firebase/model/registerService.dart';
import 'package:image_picker/image_picker.dart';

UserService userService = UserService();

class UserService {
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
}
