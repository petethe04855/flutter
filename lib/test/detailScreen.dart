import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Material Motion"),
        ),
        backgroundColor: Colors.grey[300],
        body: ListView(
          children: <Widget>[
            Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Image.network(
                      "https://storage.googleapis.com/spec-host-backup/mio-develop%2Fassets%2F1dKRB-OZstott5AMjlOqXYRmCmbf4La0R%2Fdevelop-flutter-1x1-small.png",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Lorem ipsum dolor",
                            style: TextStyle(fontSize: 28),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}
