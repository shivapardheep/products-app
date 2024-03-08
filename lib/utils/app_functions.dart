import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_app/utils/app_color.dart';
import 'package:test_app/utils/app_strings.dart';
import 'package:test_app/utils/navigation_function.dart';
import 'package:test_app/utils/persistance.dart';

class AppFunctions {
  bool isValidEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  toastFun({required String data, bool positive = false}) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: positive ? AppColor.primaryColor : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // Define a function to show the dialog
  confirmDialog(BuildContext context, String pin) {
    bool response = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to set this pin'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    ).then((value) async {
      response = value;
      if (value) {
        AppPersist().setValue(AppStrings.pinName, pin);
        NavigationFun().navToHome(context);
      }
    });
  }
}
