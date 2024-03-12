import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/products.dart';
import '../models/products_serilize.dart';

class ServicesFunctions {
  getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return user;
  }

  Future<String> uploadImage(String path) async {
    final imageFile = File(path);

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
      'productId': productId,
    };
    try {
      await productsCollection.doc(productId).set(productData);

      return true;
    } catch (e) {
      debugPrint("~~~ error is : ${e.toString()}");

      return false;
    }
  }

//  var searchResults = snapshot.docs.map((doc) => doc.data()).toList();
  filterDataFun({required String query, required id}) async {
    List<ProductSerialize> responseList = [];
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy(id ? "productId" : "name")
          .startAt([query]).endAt(['$query\ufe88']).get();
      for (final data in snapshot.docs) {
        responseList.add(ProductSerialize.fromJson(data.data()));
      }

      for (var i in responseList) {
        debugPrint("name : ${i.name}");
      }

      return responseList;
    } catch (error) {
      print('Error: $error');
      return responseList;
    }
  }
}
