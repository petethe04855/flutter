import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/test/main.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

void user() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Contacts());
}

class _ContactsState extends State<Contacts> {
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
                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "${documentSnapshot['first name']} ${documentSnapshot['first name']}",
                                  ),
                                  subtitle: Text(
                                      'Music by Julie Gable. Lyrics by Sidney Stein.'),
                                ),
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
