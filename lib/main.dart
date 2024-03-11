import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/utils/app_color.dart';
import 'package:test_app/presentation/screens/bloc/products_bloc.dart';
import 'package:test_app/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ThemeData customTheme = ThemeData(
      // primaryColor: Colors.red,
      iconTheme: const IconThemeData(color: Colors.black),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.borderColor)),
      ));

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDPfXUzAaMGlo95q_oP24h0ubcice4XzWA",
      appId: "1:528664530677:android:19c1a47d393b8d0db43fbc",
      projectId: "flutter-market-5a427",
      messagingSenderId: '528664530677',
      storageBucket: 'gs://flutter-market-5a427.appspot.com',
    ),
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (BuildContext context) => ProductsBloc(),
      ),
    ],
    child: MaterialApp(
      theme: customTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    ),
  ));
}
