import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/text/pro.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _name = TextEditingController();
  TextEditingController _qty = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  String imageUrl = '';

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('test');

  _ImageSelesFilename() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');

    if (file == null) return;

    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceBoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceBoot.child('test');

    Reference referenceDirImagesToUpload =
        referenceDirImages.child(uniqueFileName);
    print("uniqueFileName ${uniqueFileName}");

    try {
      await referenceDirImagesToUpload.putFile(File((file!.path)));
      imageUrl = await referenceDirImagesToUpload.getDownloadURL();
      print("imageUrl ${imageUrl}");
    } catch (error) {}
  }

  Updata() async {
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload an image')));

      return;
    }

    if (key.currentState!.validate()) {
      String itemName = _name.text;
      String itemQty = _qty.text;

      Map<String, String> dataToSend = {
        'name': itemName,
        'qty': itemQty,
        'image': imageUrl,
      };

      _reference.add(dataToSend);
    }
  }

  // Future<String> getNameImage(String getUrlimage) async {
  //   print("getUrlimage ${getUrlimage}");
  //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('test')
  //       .child('/' + getUrlimage);
  //   print("getUrlimage ${getUrlimage}");
  //   print("ref ${ref}");

  //   return await ref.getDownloadURL();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
              ),
              TextFormField(
                controller: _qty,
              ),

              // Icon(
              //   Icons.image_not_supported,
              //   size: 150,
              // ),
              IconButton(
                  onPressed: () {
                    _ImageSelesFilename();
                  },
                  icon: Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () {
                    Updata();
                  },
                  child: Text('submit'))
            ],
          ),
        ),
      ),
    );
  }
}
