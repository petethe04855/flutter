import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Test_Page extends StatefulWidget {
  const Test_Page({super.key});

  @override
  State<Test_Page> createState() => _Test_PageState();
}

class _Test_PageState extends State<Test_Page> {
  CollectionReference _userRole =
      FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
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
                        if (documentSnapshot['Role'] == 'ผู้ป่วย') {
                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      Image.network(documentSnapshot['images']),
                                  title: Text(
                                    "${documentSnapshot['first_name']}",
                                  ),
                                  subtitle: Text(
                                      'Music by Julie Gable. Lyrics by Sidney Stein.'),
                                ),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.edit))
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
      )),
    );
  }
}
