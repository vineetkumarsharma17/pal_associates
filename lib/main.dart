import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/Screens/admin_panel.dart';
import 'package:pal_associates/Screens/user_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/login_screen.dart';
//https://csvjson.com/csv2json
// https://beautifytools.com/excel-to-sql-converter.php
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal
        )
    ),
    debugShowCheckedModeBanner: false,
    home: SpalshPage(),
    // home: UserScreenHome(),
  ));
}
class SpalshPage extends StatefulWidget {
  const SpalshPage({Key key}) : super(key: key);

  @override
  State<SpalshPage> createState() => _SpalshPageState();
}
class _SpalshPageState extends State<SpalshPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
            (){
          check_if_already();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 250,
          height: 250,
          child: const Image(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
  void  check_if_already() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("data=============");
    print(await preferences.getBool('login'));
    bool loginstatus = await preferences.getBool('login')??true;
    if (loginstatus == false) {
      if (preferences.getString("type") == "admin") {
        Navigator.push(
            context, MaterialPageRoute(builder:
            (context) => const AdminPanelScreen())).then((value) =>
            SystemNavigator.pop());
      } else if (preferences.getString("type") == "user") {
        Navigator.push(
            context, MaterialPageRoute(builder:
            (context) => const UserScreenHome())).then((value) =>
            SystemNavigator.pop());
      } else {
        Navigator.push(context, MaterialPageRoute(builder:
            (context) => const LoginScreen())).then((value) => SystemNavigator.pop());
      }
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder:
          (context)=>const LoginScreen())).then((value) => SystemNavigator.pop());
    }
  }
}

