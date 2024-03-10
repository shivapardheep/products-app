import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/core/data/repositories/services.dart';
import 'package:test_app/presentation/screens/auth/enterpin.dart';
import 'package:test_app/presentation/screens/auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool userLogged = false;
  checkUser() async {
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final user = auth.currentUser;

    final user = await ServicesFunctions().getCurrentUser();

    if (user != null) {
      userLogged = true;
    } else {
      userLogged = false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterSplashScreen(
          useImmersiveMode: true,
          duration: const Duration(milliseconds: 2300),
          nextScreen: userLogged ? const EnterPinScreen() : const LoginScreen(),
          backgroundColor: Colors.white,
          splashScreenBody: Center(
            child: Lottie.asset(
              "assets/lottie/splash.json",
              repeat: false,
            ),
          ),
        ),
      ),
    );
  }
}
