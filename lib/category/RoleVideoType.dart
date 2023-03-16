import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/category/DetailScreen.dart';
import 'package:flutter_firebase/category/VideoName.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class RoleVideoType extends StatefulWidget {
  final String id;
  final String collection;

  const RoleVideoType({
    required this.id,
    required this.collection,
    Key? key,
  }) : super(key: key);

  @override
  State<RoleVideoType> createState() => _RoleVideoTypeState();
}

class _RoleVideoTypeState extends State<RoleVideoType> {
  XFile? file;
  String nameVideo = '';
  String img = '';
  String imageUrl = "";
  var index = [];

  @override
  Widget build(BuildContext context) {
    CollectionReference videoRole = FirebaseFirestore.instance
        .collection('VideoRole')
        .doc(widget.id)
        .collection(widget.collection);

    const sizedBoxSpace = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(widget.collection)],
              ),
              Expanded(
                child: FutureBuilder(
                  future: videoRole.get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
                    //hasData มีค่าแค่ true กับ false
                    if (snapshort.hasData) {
                      return ListView.builder(
                          itemCount: snapshort.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                snapshort.data!.docs[index];
                            var nameVideo =
                                snapshort.data!.docs[index]['NameVideo'];
                            var imageUrl =
                                snapshort.data!.docs[index]['imageVideo'];

                            return OpenContainer(
                              transitionType: ContainerTransitionType.fade,
                              transitionDuration: Duration(seconds: 1),
                              openBuilder: (context, action) {
                                return DetailScreen(
                                    videoname: documentSnapshot);
                              },
                              closedBuilder: (
                                context,
                                action,
                              ) {
                                return buildItem(documentSnapshot);
                              },
                            );
                          });
                    }
                    return Center(child: const CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(documentSnapshot) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Image.network(
            documentSnapshot['imageVideo'],
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  documentSnapshot['NameVideo'],
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "แนะนำ :" + documentSnapshot['time'] + " รอบ",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
