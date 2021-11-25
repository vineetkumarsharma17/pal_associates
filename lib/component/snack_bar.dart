import 'package:flutter/material.dart';
 showSnackBar(msg,context){
  return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    duration: const Duration(milliseconds: 2000),
  ));
}