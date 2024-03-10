import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/products.dart';

class ServicesFunctions {
  getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return user;
  }

  Future<String> uploadImage(String path) async {
    final imageFile = File(path);
    debugPrint("~~~ path : $path");

    final storageRef =
        FirebaseStorage.instance.ref('images').child('${DateTime.now()}.png');
    await storageRef.putFile(imageFile);
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl.toString();
  }

  Future<bool> addProductToFireStore(Product product) async {
    debugPrint("~~~ final");
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final CollectionReference productsCollection =
        fireStore.collection('products');

    //store image
    String imageUrl = await uploadImage(product.images);

    // Generate a unique product ID
    final String productId = productsCollection.doc().id;

    final productData = {
      'sellerId': product.sellerId,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'images': imageUrl,
      'stock': product.discount,
    };
    try {
      await productsCollection.doc(productId).set(productData);
      debugPrint('~~~ Product saved successfully!');

      return true;
    } catch (e) {
      debugPrint("~~~ error is : ${e.toString()}");

      return false;
    }
  }
}
