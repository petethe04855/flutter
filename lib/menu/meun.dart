import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/category/RoleVideoType.dart';
import 'package:flutter_firebase/menu/searchPage.dart';
import 'package:image_picker/image_picker.dart';

import '../category/category_all.dart';
import '../category/contacts.dart';
import '../login/profile.dart';

Size? size;

class Meun extends StatefulWidget {
  const Meun({super.key});

  @override
  State<Meun> createState() => _MeunState();
}

class _MeunState extends State<Meun> {
  String imageUrl = "";
  XFile? file;

  final auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  GlobalKey<ScaffoldState> _KeyMeun = new GlobalKey<ScaffoldState>();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference videoRole =
      FirebaseFirestore.instance.collection('VideoRole');

  Future<void> getVideoRole() async {
    videoRole = FirebaseFirestore.instance.collection('VideoRole');
  }

  Future<String> getNameImage(String getUrlimage) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('/' + getUrlimage);

    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String imageUrl = data['images'];

            final drawerHeader = UserAccountsDrawerHeader(
              accountName: Text("${data['first_name']}  ${data['last_name']}"),
              accountEmail: Text(data['email']),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            );
            final drawerItems = ListView(
              children: [
                drawerHeader,
                ListTile(
                  title: Text('โปรไฟล์'),
                  leading: const Icon(Icons.person_2_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) => Profile()));
                  },
                ),
                ListTile(
                  title: Text('ติดต่อผู้เชี่ยวชาญ'),
                  leading: const Icon(Icons.comment),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => Contacts()));
                  },
                ),
              ],
            );
            return Scaffold(
              key: _KeyMeun,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: (() {
                    _KeyMeun.currentState!.openDrawer();
                  }),
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => SearchPage())),
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              drawer: Drawer(
                child: drawerItems,
              ),
              body: SafeArea(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Text(
                              'ท่ากายภาพ',
                              style: TextStyle(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('หมวดหมู่'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return Category_All();
                                    }));
                                  },
                                  child: const Text('หมวดท่าทั้งหมด'),
                                ),
                              ],
                            ),
                            Container(
                              height: 100,
                              child: Flexible(
                                child: FutureBuilder(
                                    future: videoRole.get(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot>
                                            streamSnapshot) {
                                      if (!streamSnapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      }
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                              streamSnapshot.data!.docs.length,
                                          itemBuilder: (ctx, index) {
                                            return Categories(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => RoleVideoType(
                                                            id: streamSnapshot
                                                                .data!
                                                                .docs[index]
                                                                .id,
                                                            collection: streamSnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'TypeVideo'])));
                                              },
                                              VideoRoleTpye: streamSnapshot
                                                  .data!
                                                  .docs[index]['TypeVideo'],
                                              image: streamSnapshot
                                                  .data!.docs[index]['image'],
                                            );
                                          });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}

class Categories extends StatelessWidget {
  final String VideoRoleTpye;
  final String image;
  final Function()? onTap;
  const Categories({
    required this.onTap,
    required this.VideoRoleTpye,
    required this.image,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(12.0),
        width: size!.width / 2 - 20,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(image),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              VideoRoleTpye,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
