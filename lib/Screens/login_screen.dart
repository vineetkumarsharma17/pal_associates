import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/Screens/admin_panel.dart';
import 'package:pal_associates/Screens/otp_screen.dart';
import 'package:pal_associates/Screens/admin_search.dart';
import 'package:pal_associates/Screens/user_homepage.dart';
import 'package:pal_associates/component/alertdilog.dart';
import 'package:pal_associates/component/component.dart';
import 'package:pal_associates/component/constrainst.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var mobileCtrl = TextEditingController();
  String mobile = '';
  bool loading = true;
  String id, status;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pal Associates"),
        // automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          Positioned(
            // top: 9,
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
              child: Column(
                children: [
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: "   Welcome to",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.yellow[700],
                                ),
                                children: [
                                  TextSpan(
                                    text: "\nPal Associates,",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  )
                                ]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // margin: EdgeInsets.only(left: 60),
                            child: Text(
                              "Signin to Continue",
                              style: TextStyle(
                                  letterSpacing: 3, color: Colors.blueGrey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    // padding: EdgeInsets.only(),
                    child: Column(
                      children: [
                        TextField(
                          controller: mobileCtrl,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Palette.iconColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Palette.textColor1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Palette.textColor1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefix: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: Text(
                                "(+91)",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(20),
                            hintText: "Enter Mobile Number",
                            hintStyle: TextStyle(
                                fontSize: 14, color: Palette.textColor1),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(top: 20),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "By pressing 'Submit' you agree to our ",
                                style: TextStyle(color: Palette.textColor2),
                                children: [
                                  TextSpan(
                                    // recognizer: ,
                                    text: "term & conditions",
                                    style: TextStyle(color: Colors.orange),
                                  )
                                ]),
                          ),
                        ),
                      ],
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
                    mobile = mobileCtrl.text;
                    if (validate()) {
                      setState(() {
                        loading = false;
                      });
                      checkUser();
                    }
                    //  sendOtp();
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

  bool validate() {
    if (mobile.isEmpty) {
      showSnackBar("Empty Mobile", context);
      return false;
    } else if (mobile.length != 10) {
      showSnackBar("Invalid mobile number!", context);
      return false;
    }
    return true;
  }

  void checkUser() async {
    status = "false";
    var errorMessage = "";
    print(mobile);
    try {
      await phone
          .where('number', isEqualTo: mobile)
          .get()
          .then((QuerySnapshot querySnapshot) {
        print(querySnapshot.docs.toString());
        querySnapshot.docs.forEach((doc) {
          id = doc.id;
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          status = data['status'];
          print("this is status ${status}");
          print(id);
        });
      });
    } catch (error) {
      setState(() {
        loading = true;
      });
      if (error is FirebaseAuthException) {
        print(error.code);
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
    if (status == "true" || status == "admin") {
      phone.doc(id).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          sendOTP();
          // showMyDialog("Success", "Authorised", context);
        } else {
          print("not exist");
          // Navigator.push(context,
          // MaterialPageRoute(builder: (context) => Home()));
        }
      });
    } else {
      setState(() {
        loading = true;
      });
      String msg =
          "You are not authorized to use this app\nPlease Contact to Sunil Pal.";
      showMyDialog("Failed", msg, context);
    }
  }

  void sendOTP() async {
    try {
      auth
          .verifyPhoneNumber(
        phoneNumber: '+91' + mobile,
        timeout: Duration(seconds: 25),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('login', false);
          prefs.setString('number', mobile);
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
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserScreenHome()))
                .then((value) => SystemNavigator.pop());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            loading = true;
          });
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            //print("=============================verified");
            print(e);
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          showSnackBar("Code sent to ${mobile} Successfully", context);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            prefs.setString('number', mobile);
            loading = true;
          });
          print("code sent to " + mobile);
          print(verificationId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        verificationId: verificationId,
                        status: status,
                        mobile: mobile,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("=============================timeout");
          print("Timeout");
        },
      )
          .catchError((e) {
        setState(() {
          loading = true;
        });
        print("error==========cathcj");
        print(e.toString());
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = true;
      });
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
}
