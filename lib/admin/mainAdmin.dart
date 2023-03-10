import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/admin/updata.dart';
import 'package:flutter_firebase/model/updataDR.dart';
import 'package:path_provider/path_provider.dart';

import '../category/contacts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class main_Admin extends StatefulWidget {
  const main_Admin({super.key});

  @override
  State<main_Admin> createState() => _main_AdminState();
}

class _main_AdminState extends State<main_Admin> {
  var status = 1;
  var uid;
  CollectionReference _userRole =
      FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ผู้เชี่ยวชาญ"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [],
        elevation: 0,
      ),
      body: Container(
        child: Column(children: [
          Center(
            child: Text(
              'ผู้เชี่ยวชาญ',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: StreamBuilder(
              stream: _userRole.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        if (documentSnapshot['Role'] == 'หมอ') {
                          var dataUid = documentSnapshot['uid'];
                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "${documentSnapshot['first_name']}",
                                  ),
                                  subtitle: Text(
                                      'Music by Julie Gable. Lyrics by Sidney Stein.'),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          CupertinoPageRoute(builder: (_) {
                                        return updata(
                                            dataUid: documentSnapshot);
                                      }));
                                    },
                                    icon: Icon(Icons.edit))
                              ],
                            ),
                          );
                        }
                        return Text("");
                      });
                }
                return Text("Loading...");
              },
            ),
          )
        ]),
      ),
    );
  }
}
