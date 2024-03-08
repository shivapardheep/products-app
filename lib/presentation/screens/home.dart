import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/utils/navigation_function.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  logoutFun() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => NavigationFun().navToLogin(context));
    // NavigationFun().navToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors
                  .orange, // Set default background color for all ElevatedButtons
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              logoutFun();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
