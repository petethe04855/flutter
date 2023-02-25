import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Check_account check_account = Check_account();

class Check_account {
  final _auth = FirebaseAuth.instance;

  void check_uid(String uid) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });
  }
}
