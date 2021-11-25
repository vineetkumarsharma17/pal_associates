import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/Screens/admin_panel.dart';
import 'package:pal_associates/Screens/otp_screen.dart';
import 'package:pal_associates/Screens/user_homepage.dart';
import 'package:pal_associates/component/alertdilog.dart';
import 'package:pal_associates/component/component.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var cnumber=TextEditingController();
   String mobile='';
  bool loading=true;
  String id,status;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  FirebaseAuth auth = FirebaseAuth.instance;

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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Image.asset(
                'assets/images/registration.png',
                height: screenHeight * 0.2,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),

              const Text(
                'Log  In',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.teal,
                  fontFamily: "Anton",
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              const Text(
                'Enter your mobile number to receive a verification code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16.0)),
                child: Column(
                  children: [
                    loading?Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 253, 188, 51),
                        ),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Contact Number',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefixText: "+91",
                                contentPadding: EdgeInsets.symmetric(vertical: 13.5),
                              ),
                              controller: cnumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: [LengthLimitingTextInputFormatter(10)],
                            ),
                          ),
                        ],
                      ),
                    ):const CircularProgressIndicator(
                      color: Colors.yellow,
                      backgroundColor: Colors.teal,
                      strokeWidth: 5,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: (){
                        mobile=cnumber.text;
                       if(validate()){
                         setState(() {
                           loading=false;
                         });
                         checkUser();
                       }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 253, 188, 51),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Send OTP',
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  bool validate(){
    if(mobile.isEmpty) {
      showSnackBar("Empty Mobile", context);
      return false;
    }else
    if(mobile.length!=10){
      showSnackBar("Invalid mobile number!", context);
      return false;
    }
    return true;
  }
  void checkUser()async{
    status="false";
    var errorMessage="";
    print(mobile);
    try{
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
    }catch(error){
      setState(() {
        loading=true;
      });
      if(error is FirebaseAuthException) {
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
    if (status == "true"||status=="admin") {
      phone
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
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
        loading=true;
      });
      String msg="You are not authorized to use this app\nPlease Contact to Sunil Pal.";
      showMyDialog("Failed", msg, context);
    }
  }
  void sendOTP()async{
    try{auth.verifyPhoneNumber(
      phoneNumber: '+91'+mobile,
      timeout: Duration(seconds: 25),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('login',false);
        showSnackBar("Verified Successfully",context);
        if(status=="admin") {
          prefs.setString('type',"admin");
          Navigator.push(context, MaterialPageRoute(builder:
              (context)=>const AdminPanelScreen())).then((value) => SystemNavigator.pop());
        } else {
          prefs.setString('type',"user");
          Navigator.push(context, MaterialPageRoute(builder:
              (context)=>const UserScreenHome())).then((value) => SystemNavigator.pop());
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          loading=true;
        });
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          //print("=============================verified");
          print(e);}
      },
      codeSent: (String verificationId, int resendToken)async {
        showSnackBar("Code sent to ${mobile} Successfully",context);
       setState(() {
         loading=true;
       });
        print("code sent to "+mobile);
        print(verificationId);
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=>OtpScreen(verificationId: verificationId,status: status,mobile: mobile,)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("=============================timeout");
        print("Timeout");
      },
    ).catchError((e){
      setState(() {
        loading=true;
      });
      print("error==========cathcj");
      print(e.toString());
    });
    }
    on FirebaseAuthException catch  (e) {
      setState(() {
        loading=true;
      });
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
}
