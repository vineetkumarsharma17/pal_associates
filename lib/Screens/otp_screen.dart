import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/Screens/admin_panel.dart';
import 'package:pal_associates/Screens/user_homepage.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OtpScreen extends StatefulWidget {
  final  verificationId,status,mobile;
  const OtpScreen({Key? key, this.verificationId, this.status,this.mobile}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState(verificationId,status,mobile);
}

class _OtpScreenState extends State<OtpScreen> {
  final verificationId,status,mobile;
  String smsOTP='';
  bool loading=true;
  String errorMessage='';

  _OtpScreenState(this.verificationId, this.status, this.mobile);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
        title: Text("Pal Associations"),
    // automaticallyImplyLeading: false,
    ),
    drawer: MyDrawer(),
      body: Center(
        child: SingleChildScrollView(
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
                  'assets/images/verification.png',
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'Verification',
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                 Text(
                  //TODO number lagana hai
                  'Enter A 6 digit number that was sent to ${widget.mobile}',
                  // 'Enter A 6 digit number that was sent to ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // margin: EdgeInsets.only(left: screenWidth * 0.025),
                        child:loading? PinEntryTextField(
                          showFieldAsBox: true,
                          fields: 6,
                          onSubmit: (text) {
                            smsOTP = text as String;
                          },
                        ):const CircularProgressIndicator(
                          color: Colors.yellow,
                          backgroundColor: Colors.teal,
                          strokeWidth: 5,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      GestureDetector(
                        onTap: () {
                          print(smsOTP);
                         if(validate()){
                           setState(() {
                             loading=false;
                           });
                           verifyOTP();
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
                            'Verify',
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
      ),
    );
  }
  void verifyOTP()async {
    print("verify with"+smsOTP);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsOTP);
    try{
      final User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
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
      print("Successfully signed in UID: ${user!.uid}");
    }catch ( error) {
      setState(() {
        loading=true;
      });
      if(error is FirebaseAuthException) {
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
  bool validate(){
    if(smsOTP.isEmpty) {
      showSnackBar("Empty Otp", context);
      return false;
    }else
    if(smsOTP.length!=6){
      showSnackBar("Otp must have 6 digits!", context);
      return false;
    }
    return true;
  }
}
