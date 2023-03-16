import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Product_Page extends StatefulWidget {
  const Product_Page({super.key});

  @override
  State<Product_Page> createState() => _Product_PageState();
}

class _Product_PageState extends State<Product_Page> {
  String _selectedType = "all";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  String name = 'product';
  String price = '50';
  String description = 'dasdsad';

  add() async {
    DocumentReference productDocRef =
        FirebaseFirestore.instance.collection('product').doc('product1');

    productDocRef.set({
      'name': 'Example Product',
      'description': 'This is an example product.',
      'price': 9.99,
    });

    CollectionReference productTypeCollectionRef =
        productDocRef.collection('productTypes');

    productTypeCollectionRef.add({
      'name': 'Example Product Type',
      'description': 'This is an example product type.',
    });
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () {
              add();
            },
            child: Text('dsad')),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedType = "all";
            });
          },
          child: Text("All"),
          style: TextButton.styleFrom(
            backgroundColor: _selectedType == "all" ? Colors.blue : Colors.grey,
            primary: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedType = "type1";
            });
          },
          child: Text("Type 1"),
          style: TextButton.styleFrom(
            backgroundColor:
                _selectedType == "type1" ? Colors.blue : Colors.grey,
            primary: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedType = "type2";
            });
          },
          child: Text("Type 2"),
          style: TextButton.styleFrom(
            backgroundColor:
                _selectedType == "type2" ? Colors.blue : Colors.grey,
            primary: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _selectedType == "all"
          ? _db.collection("products").snapshots()
          : _db
              .collection("products")
              .where("type", isEqualTo: _selectedType)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final data = documents[index].data() as Map<String, dynamic>;
            final String name = data['name'];
            final String price = data['price'];
            final String imageUrl = data['imageUrl'];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              title: Text(name),
              subtitle: Text(price),
            );
          },
        );
      },
    );
  }
}
