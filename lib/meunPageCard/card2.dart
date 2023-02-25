import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Card_2 extends StatefulWidget {
  const Card_2({super.key});

  @override
  State<Card_2> createState() => _Card_2State();
}

class _Card_2State extends State<Card_2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card 2"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Page2",
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("กลับสู่หน้าหลัก",
                  style: TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      ),
    );
  }
}
