import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showMyDialog(
    String msg, String detail, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showExitDialog(
    String msg, String detail, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setBool("login", true);
              Navigator.of(context).pop();
              showSnackBar(
                  "Thanks for using our app\nThis app is developed by Vineet Kumar Sharma(8874327867)",
                  context);
              Timer(const Duration(seconds: 3), () {
                // Navigator.of(context).pop();
                // showSnackBar("after timer",context);
                SystemNavigator.pop();
              });
            },
          ),
        ],
      );
    },
  );
}
