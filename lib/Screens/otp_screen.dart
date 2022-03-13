import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pal_associates/Screens/admin_panel.dart';
import 'package:pal_associates/Screens/admin_search.dart';
import 'package:pal_associates/Screens/user_homepage.dart';
import 'package:pal_associates/Screens/user_profile_screen.dart';
import 'package:pal_associates/component/constrainst.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final verificationId, status, mobile;
  const OtpScreen({Key key, this.verificationId, this.status, this.mobile})
      : super(key: key);

  @override
  _OtpScreenState createState() =>
      _OtpScreenState(verificationId, status, mobile);
}

class _OtpScreenState extends State<OtpScreen> {
  final verificationId, status, mobile;
  String smsOTP = '';
  bool loading = true;
  String errorMessage = '';

  _OtpScreenState(this.verificationId, this.status, this.mobile);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pal Associates"),
        // automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          Positioned(
            //top: 9,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/otp.webp"),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          // main Container for login and Signup
          Positioned(
            top: 200,
            child: Container(
              height: 380,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      "Verification",
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                  ),
                  SizedBox(height: 40),
                  OTPTextField(
                    length: 6,
                    //width: MediaQuery.of(context).size.width,
                    fieldWidth: 40,
                    style: TextStyle(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    onCompleted: (pin) {
                      setState(() {
                        smsOTP = pin;
                      });
                      print("Completed: " + pin);
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "By pressing 'Submit' you agree\n to our ",
                          style: TextStyle(color: Palette.textColor2),
                          children: [
                            TextSpan(
                              // recognizer: ,
                              text: "term & conditions",
                              style: TextStyle(color: Colors.orange),
                            )
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          //Trick to add the submit button
          Positioned(
            top: 535,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                height: 90,
                width: 90,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ]),
                child: GestureDetector(
                  onTap: () {
                    // verify();
                    print(smsOTP);
                    if (validate()) {
                      setState(() {
                        loading = false;
                      });
                      verifyOTP();
                    }
                  },
                  child: loading
                      ? Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ]),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
                      : CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void verifyOTP() async {
    print("verify with" + smsOTP);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsOTP);
    try {
      final User user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('login', false);
      showSnackBar("Verified Successfully", context);
      if (status == "admin") {
        prefs.setString('type', "admin");
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminPanelScreen()))
            .then((value) => SystemNavigator.pop());
      } else {
        prefs.setString('type', "user");
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserProfile()))
            .then((value) => SystemNavigator.pop());
      }
      print("Successfully signed in UID: ${user.uid}");
    } catch (error) {
      setState(() {
        loading = true;
      });
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case "invalid-verification-code":
            errorMessage = "Wrong Otp!.";
            break;
          case "network-request-failed":
            errorMessage = "Check Internet Connection.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          default:
            print(error.code);
            errorMessage = "An undefined Error happened.";
        }
        showSnackBar(errorMessage, context);
      }
    }
  }

  bool validate() {
    if (smsOTP.isEmpty) {
      showSnackBar("Empty Otp", context);
      return false;
    } else if (smsOTP.length != 6) {
      showSnackBar("Otp must have 6 digits!", context);
      return false;
    }
    return true;
  }
}
