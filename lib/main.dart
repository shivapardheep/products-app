import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app/presentation/screens/add_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ThemeData customTheme = ThemeData(
      primaryColor: Colors.red, // Change the primary color (app bar color)
      // Change the button color
      iconTheme: const IconThemeData(color: Colors.black),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      ));

  // try {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDPfXUzAaMGlo95q_oP24h0ubcice4XzWA",
      appId: "1:528664530677:android:19c1a47d393b8d0db43fbc",
      projectId: "flutter-market-5a427",
      messagingSenderId: '528664530677',
    ),
  );
  // } catch (e) {
  //   debugPrint("~~~Error is : $e");
  // logger.e(e.toString());
  // }
  runApp(MaterialApp(
    theme: customTheme,
    debugShowCheckedModeBanner: false,
    home: const AddProductsScreen(),
  ));
}
