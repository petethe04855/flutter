import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Category_1 extends StatefulWidget {
  const Category_1({super.key});

  @override
  State<Category_1> createState() => _Category_1State();
}

class _Category_1State extends State<Category_1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card 1"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Page1",
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("กลับสู่หน้าหลัก",
                  style: TextStyle(color: Colors.amber)),
            )
          ],
        ),
      ),
    );
  }
}
