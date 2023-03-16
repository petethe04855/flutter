import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String type;
  final String description;
  final double price;
  final String imageUrl;

  Product(
      {required this.name,
      required this.type,
      required this.description,
      required this.price,
      required this.imageUrl});
}

class ProductService {
  static Future<List<Product>> getProductsByType(String type) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('type', isEqualTo: type)
        .get();

    List<Product> products = [];
    querySnapshot.docs.forEach((documentSnapshot) {
      products.add(Product(
          name: documentSnapshot['name'],
          type: documentSnapshot['type'],
          description: documentSnapshot['description'],
          price: documentSnapshot['price'],
          imageUrl: documentSnapshot['imageUrl']));
    });

    return products;
  }

  static Future<List<Product>> getAllProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    List<Product> products = [];
    querySnapshot.docs.forEach((documentSnapshot) {
      products.add(Product(
          name: documentSnapshot['name'],
          type: documentSnapshot['type'],
          description: documentSnapshot['description'],
          price: documentSnapshot['price'],
          imageUrl: documentSnapshot['imageUrl']));
    });

    return products;
  }
}
