import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_firebase/test/detailScreen.dart';

class TestCard extends StatefulWidget {
  const TestCard({super.key});

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Material Motion"),
        ),
        backgroundColor: Colors.grey[300],
        body: ListView(
          children: <Widget>[
            OpenContainer(
              transitionType: ContainerTransitionType.fade,
              transitionDuration: Duration(seconds: 1),
              openBuilder: (context, action) {
                return DetailScreen();
              },
              closedBuilder: (context, action) {
                return buildItem();
              },
            )
          ],
        ));
  }

  Widget buildItem() {
    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Image.network(
              "https://storage.googleapis.com/spec-host-backup/mio-develop%2Fassets%2F1dKRB-OZstott5AMjlOqXYRmCmbf4La0R%2Fdevelop-flutter-1x1-small.png",
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
                    "Lorem ipsum dolor",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
