import 'package:flutter/material.dart';
import 'package:test_app/presentation/screens/add_products.dart';
import 'package:test_app/presentation/screens/auth/enterpin.dart';
import 'package:test_app/presentation/screens/auth/setpin.dart';
import 'package:test_app/presentation/screens/home.dart';
import 'package:test_app/presentation/screens/product_details.dart';

import '../../presentation/screens/auth/login.dart';
import '../../presentation/screens/auth/register.dart';

class NavigationFun {
  navToLogin(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false);
  }

  navToRegister(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
        (route) => false);
  }

  navToHome(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false);
  }

  navToSetPin(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SetPinScreen()),
        (route) => false);
  }

  navToEnterPin(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const EnterPinScreen()),
        (route) => false);
  }

  navToAddProductScreen(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const AddProductsScreen()));
  }

  navToProductDetailsScreen(context, product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product)));
  }
}
