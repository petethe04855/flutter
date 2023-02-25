import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

import 'model/registerService.dart';

class Page_2 extends StatefulWidget {
  const Page_2({super.key});

  @override
  State<Page_2> createState() => _Page_2State();
}

class _Page_2State extends State<Page_2> {
  String selectFileName = "";
  XFile? file;

  _selectFile(bool imageFrom) async {
    file = await ImagePicker().pickImage(
      source: imageFrom ? ImageSource.gallery : ImageSource.camera,
    );

    if (file != null) {
      setState(() {
        selectFileName = file!.name;
      });
    }
    print("selectFileName ${selectFileName}");
    print("file?.name ${file?.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("image"),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Center(
                child: selectFileName.isEmpty
                    ? Image.network(
                        "https://www.techhub.in.th/wp-content/uploads/2021/05/118283916_b19c5a1f-162b-410b-8169-f58f0d153752.jpg")
                    : Image.file(
                        File(file!.path),
                        fit: BoxFit.fill,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: ElevatedButton(
                  child: Wrap(
                    children: [
                      Icon(Icons.camera),
                      Text('รูปถ่าย'),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Wrap(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text(
                                  "รูปภาพ",
                                  style: TextStyle(),
                                ),
                                onTap: () {
                                  _selectFile(true);
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text(
                                  "กล่อง",
                                  style: TextStyle(),
                                ),
                                onTap: () {
                                  _selectFile(false);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
