import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userUid;
  final String first_name;
  final String last_name;
  final String email;
  final String time;
  final String phomeNumber;
  final String address;
  final String symptomAry_2;
  final String IDline;
  final String rool;
  final String imageUser;

  UserModel({
    required this.userUid,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.time,
    required this.phomeNumber,
    required this.address,
    required this.symptomAry_2,
    required this.IDline,
    required this.rool,
    required this.imageUser,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      userUid: doc['uid'],
      first_name: doc['first_name'],
      last_name: doc['last_name'],
      email: doc['email'],
      time: doc['time'],
      phomeNumber: doc['phomeNumber'],
      address: doc['address'],
      symptomAry_2: doc['symptomAry_2'],
      IDline: doc['IDline'],
      rool: doc['rool'],
      imageUser: doc['imageUser'],
    );
  }
}
