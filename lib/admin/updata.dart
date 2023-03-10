import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/model/updataDR.dart';

class updata extends StatefulWidget {
  final DocumentSnapshot dataUid;
  const updata({super.key, required this.dataUid});

  @override
  State<updata> createState() => _updataState();
}

class _updataState extends State<updata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                updataDR.updateUsersStatus(context, widget.dataUid);
              },
              child: Text("updata"))
        ]),
      )),
    );
  }
}
