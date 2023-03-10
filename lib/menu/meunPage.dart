import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/category/category_all.dart';
import 'package:flutter_firebase/category/category_neck.dart';
import 'package:flutter_firebase/category/contacts.dart';
import 'package:flutter_firebase/login/profile.dart';
import 'package:flutter_firebase/menu/searchPage.dart';
import 'package:flutter_firebase/meunPageCard/card1.dart';

class MeunPage extends StatefulWidget {
  const MeunPage({super.key});

  @override
  State<MeunPage> createState() => _MeunPageState();
}

final auth = FirebaseAuth.instance;

class _MeunPageState extends State<MeunPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    print("auth-uid ${auth.currentUser!.uid}");
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 16,
        child: Container(
          width: 100,
          height: 100,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              IconButton(
                color: Color.fromARGB(255, 0, 0, 0),
                icon: Icon(
                  Icons.clear,
                  size: 30,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://picsum.photos/seed/974/600',
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: const Text('โปรไฟล์ 1'),
                onTap: () {
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => Profile()));
                },
              ),
              ListTile(
                title: const Text('ติดต่อผู้เชี่ยวชาญ'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => Contacts()));
                },
              ),
              ListTile(
                title: const Text('เชื่อมต่ออุปกรณ์'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFAAC4FF),
        title: Center(
          child: Text(
            "ยินดีต้อนรับ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (() {
            _scaffoldKey.currentState!.openDrawer();
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
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFAAC4FF),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Text(
                      'Hello World',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hello World'),
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
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0, 255, 255, 255),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      children: [
                        //หมวดหมู่ 1

                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                          child: Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFBFA2DB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => Category_neck(),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'https://picsum.photos/seed/479/600',
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: ElevatedButton(
                                    child: const Text(
                                      'คอ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  Category_neck()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //ช่อง 2

              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello World',
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Hello World'),
                    ),
                  ],
                ),
              ),
////////////////////////////////////////////////////////////////
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    ////////////////////////////////////////////////////////////////
                    //ท่า 1

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFBFA2DB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'https://picsum.photos/seed/479/600',
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: ElevatedButton(
                                child: const Text(
                                  'ท่า 1',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ////////////////////////////////////////////////////////////////
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void searchPage(BuildContext context) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) {
    return SearchPage();
  }));
}
