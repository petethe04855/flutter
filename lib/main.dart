import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase/category/contacts.dart';
import 'package:flutter_firebase/login/login_page.dart';
import 'package:flutter_firebase/login/profile.dart';
import 'package:flutter_firebase/login/profileEdit.dart';
import 'package:flutter_firebase/login/register.dart';
import 'package:flutter_firebase/login/register_test.dart';
import 'package:flutter_firebase/menu/meun.dart';
import 'package:flutter_firebase/menu/meunPage.dart';
import 'package:flutter_firebase/meunPageCard/card1.dart';
import 'package:flutter_firebase/page_1.dart';
import 'package:flutter_firebase/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/test/dataimage.dart';
import 'package:flutter_firebase/test/image.dart';
import 'package:flutter_firebase/test/imagedata.dart';
import 'package:flutter_firebase/test/product.dart';
import 'package:flutter_firebase/test/testCard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Meun(
              //title: "tset",
              ),
        ),
      ),
    );
  }
}
