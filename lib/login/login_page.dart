import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/admin/mainAdmin.dart';
import 'package:flutter_firebase/dr/wait.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/login/register.dart';
import 'package:flutter_firebase/login/register_test.dart';
import 'package:flutter_firebase/menu/meunPage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  String? testText;
  final formKey = GlobalKey<FormState>();
  late bool passwordVisibility = true;
  late bool confirm_passwordVisibility = true;

  void _toggle() {
    setState(() {
      passwordVisibility = !passwordVisibility;
      confirm_passwordVisibility = !confirm_passwordVisibility;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
            body: SafeArea(
              child: Container(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Center(
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: TextFormField(
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "กรุณาป้อมอีกเมล"),
                                  EmailValidator(
                                      errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                                ]),
                                controller: email,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextFormField(
                                controller: password,
                                validator: RequiredValidator(
                                    errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"),
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
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                child: ElevatedButton(
                                  child: Text("ลงชื่อเข้าใช้"),
                                  onPressed: () {
                                    signIn(email.text, password.text);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("สมัครสมาชิก"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Register_test(),
                                        ),
                                      );
                                    },
                                    child: Text("สมัคร"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('Role') == "หมอ") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Wait_Page(),
            ),
          );
        } else if (documentSnapshot.get('Role') == "ผู้ป่วย") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MeunPage(),
            ),
          );
        } else if (documentSnapshot.get('Role') == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => main_Admin(),
            ),
          );
        }
      }
    });
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('เข้าสู่ระบบสำเร็จ'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  void signIn(String email, String password) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
