import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/component/share_to_whatsapp.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'alertdilog.dart';
logoutActionButton(context){
  return FloatingActionButton(
    child: Icon(Icons.logout),
      onPressed:()async{
  showExitDialog("Alert!", "Are you sure to exit?", context);
   //exit(0);
  });
}
buttonStyle(){
  return ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(120, 40)),
      backgroundColor: MaterialStateProperty.all(Colors.teal),
      shape:MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(20),
          side: BorderSide.none
      ))
  );
}
Future<void> showDataDialog(String msg,String detail,BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Share'),
            onPressed: () async {
              print("clicked");
              Navigator.of(context).pop();
              openwhatsapp(detail, context);
            },
          ),
          TextButton(
            child: const Text('Copy'),
            onPressed: () async {
              print("clicked");
              Navigator.of(context).pop();
              Clipboard.setData(ClipboardData(text: detail));
            },
          ),
        ],
      );
    },
  );
}
Future<void> AddUserDialog( msg, detail,mobile, context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () async {
              print("clicked");
              addPhoneNumber(mobile, context);
              // Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

 addPhoneNumber(mobile,context){
   CollectionReference phone = FirebaseFirestore.instance.collection('phone');
   phone.add({
     'number': mobile, // John Doe
     'status': "true", // Stokes and Sons
   }).then((value) {
     Navigator.of(context).pop();
     showSnackBar("Invited SuccessFully!", context);
     String msg = "I Invited you on Pal Associates app .Please download our app from https://vkwilson.email/";
     openwhatsapp(msg, context);
     // Navigator.of(context).pop();
   }).catchError((error) {
     print(error.toString());
     Navigator.of(context).pop();
     return showMyDialog("Error", error.toString(), context);
   });
 }