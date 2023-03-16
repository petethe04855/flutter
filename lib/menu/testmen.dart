import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class testMeun extends StatefulWidget {
  const testMeun({
    Key? key,
  }) : super(key: key);

  @override
  State<testMeun> createState() => _testMeunState();
}

class _testMeunState extends State<testMeun> {
  String _TypeVideo = '';
  String _image = '';

  final auth = FirebaseAuth.instance;

  Future<void> _getUserData() async {
    FirebaseFirestore.instance
        .collection('VideoRole')
        .doc('eE0OcmSJpDx0anAbljmB')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _TypeVideo = data['TypeVideo'];

          _image = data['image'];
        });
      } else {
        print("Document does not exist in the database");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getUserData();
  }

  @override
  Widget build(BuildContext context) {
    print("_image ${_image}");
    print("_TypeVideo ${_TypeVideo}");
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_TypeVideo),
              accountEmail: Text(_image),
              currentAccountPicture: CircleAvatar(),
            ),
            // add other drawer items here
          ],
        ),
      ),
    );
  }
}
