import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/navigation_function.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  bool pwdVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  loginFun() async {
    // Call the user's CollectionReference to add a new user
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
      clearTextFields();
      AppFunctions().toastFun(data: "Login Successfully", positive: true);

      NavigationFun().navToSetPin(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppFunctions().toastFun(data: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        AppFunctions().toastFun(data: "Wrong password provided for that user.");
      } else {
        AppFunctions().toastFun(data: 'check email or password is wrong');
      }
    }
  }

  clearTextFields() {
    emailController.clear();
    passController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, top: 35),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/login.jpg', // Replace with your logo path
                  height: 250.0,
                  // width: 100.0,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 20.0),

                // Email field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    focusColor: AppColor.primaryColor,
                    hoverColor: AppColor.primaryColor,
                    border: const OutlineInputBorder(
                      // borderSide: BorderSide(
                      //     color: Colors.red), // Change border color here

                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColor.greyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!AppFunctions().isValidEmail(value)) {
                      return 'please enter valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => _email = value!),
                ),

                const SizedBox(height: 20.0),

                // Password field
                TextFormField(
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    focusColor: AppColor.primaryColor,
                    hoverColor: AppColor.primaryColor,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColor.greyColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        pwdVisible
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        color: AppColor.greyColor,
                      ),
                      onPressed: () {
                        setState(() {
                          pwdVisible = !pwdVisible;
                        });
                      }, // Handle password visibility toggle
                    ),
                  ),
                  obscureText: !pwdVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => _password = value!),
                ),

                const SizedBox(height: 40.0),

                // Login button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        loginFun();
                        // Handle login logic with email and password
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // register link (optional)
                TextButton(
                  onPressed: () => NavigationFun().navToRegister(
                      context), // Handle forgot password functionality
                  child: Text(
                    'Register account',
                    style: TextStyle(color: AppColor.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
