import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/navigation_function.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool pwdVisible = false;

  signupFun() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      //store to database
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users
          .add({
            'name': nameController.text, // John Doe
            'email': emailController.text, // Stokes and Sons
            'userid': credential.user!.uid, // 42
          })
          .then((value) => debugPrint("User Added"))
          .catchError((error) => debugPrint("Failed to add user: $error"));

      AppFunctions().toastFun(data: "Registered Successfully", positive: true);

      clearTextFields();
      NavigationFun().navToSetPin(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppFunctions().toastFun(data: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        AppFunctions()
            .toastFun(data: "The account already exists for that email.");
      }
    } catch (e) {
      AppFunctions().toastFun(data: e.toString());
    }
  }

  clearTextFields() {
    nameController.clear();
    emailController.clear();
    passController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/signup.jpg', // Replace with your logo path
                    height: 250.0,
                    // width: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20.0),

                // Name field
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    focusColor: AppColor.primaryColor,
                    hoverColor: AppColor.primaryColor,
                    border: const OutlineInputBorder(
                      // borderSide: BorderSide(
                      //     color: Colors.red), // Change border color here

                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColor.greyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name ';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => _name = value!),
                ),
                const SizedBox(height: 20.0),

                // Email field
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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

                // Register button
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
                        signupFun();
                        // Handle login logic with email and password
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // register link (optional)
                Center(
                  child: TextButton(
                    onPressed: () => NavigationFun().navToLogin(
                        context), // Handle forgot password functionality
                    child: Text(
                      'Login account',
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
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
