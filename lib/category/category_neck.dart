import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/meunPageCard/card1.dart';
import 'package:flutter_firebase/meunPageCard/card2.dart';

class Category_neck extends StatefulWidget {
  const Category_neck({super.key});

  @override
  State<Category_neck> createState() => _Category_neckState();
}

class _Category_neckState extends State<Category_neck> {
  @override
  Widget build(BuildContext context) {
    CollectionReference video = FirebaseFirestore.instance.collection('Video');
    return Scaffold(
      appBar: AppBar(
        title: const Text("หมวดท่า"),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFAAC4FF),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "หมวดท่า",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: StreamBuilder(
                  stream: video.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            if (documentSnapshot['RoleVideo'] == 'ต้นคอ') {
                              return Center(
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              CupertinoPageRoute(builder: (_) {
                                            return Card_2(
                                                videoname: documentSnapshot);
                                          }));
                                        },
                                        child: ListTile(
                                          leading: Text(""),
                                          title: Text(
                                              documentSnapshot['NameVideo']),
                                          subtitle: Text(
                                              "${documentSnapshot['time']}"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          });
                    }
                    return Text("Loading...");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
