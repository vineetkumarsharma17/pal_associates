import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/component/alertdilog.dart';
import 'package:pal_associates/component/component.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/share_to_whatsapp.dart';
import 'package:pal_associates/component/snack_bar.dart';
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key key}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  var cnumber=TextEditingController();
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  String mobile='';
  bool loading=true;
  var id;
  String status;
  var text_style=const TextStyle(
      color: Colors.teal,
      // fontSize: 20,
      fontWeight: FontWeight.bold
  );
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pal Associates"),
        actions:  [
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child:IconButton(
                  onPressed: ()=>showExitDialog("Alert!", "Are you sure to exit?", context),
                  icon: Icon(Icons.logout))
          ),
        ],
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

                const Text(
                  'Welcome Admin ',
                  style: TextStyle(
                      fontSize: 28,
                    color: Colors.teal,
                    fontFamily: "Pacifico",
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Column(
                  children: [
                    loading?Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      height: 45,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            mobile=cnumber.text;
                           if(validate()){
                             setState(() {
                               loading=false;
                             });
                             addPhoneNumber();
                           }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 253, 188, 51),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            margin: EdgeInsets.all(10),
                            width: screenWidth*.25,
                            height: screenWidth*.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add),
                                Text("Invite as",style: text_style,),
                                Text("User",style: text_style,),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                            border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 253, 188, 51),
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          margin: EdgeInsets.all(10),
                          width: screenWidth*.25,
                          height: screenWidth*.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.admin_panel_settings_outlined),
                              Text("Invite as",style: text_style,),
                              Text("Admin",style: text_style,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(onTap: (){
                          mobile=cnumber.text;
                          if(validate()){
                            setState(() {
                              loading=false;
                            });
                            checkstatus();
                          }
                        },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 253, 188, 51),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            margin: EdgeInsets.all(10),
                            width: screenWidth*.25,
                            height: screenWidth*.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.verified_outlined,
                                ),
                                Text("Check",style: text_style,),
                                Text("Number",style: text_style,),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(onTap: (){
                          mobile=cnumber.text;
                          if(validate()){
                            setState(() {
                              loading=false;
                            });
                            blockUser();
                          }
                        },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 253, 188, 51),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            margin: EdgeInsets.all(10),
                            width: screenWidth*.25,
                            height: screenWidth*.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.block_flipped),
                                Text("Block",style: text_style,),
                                Text("User",style: text_style,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(onTap: (){
                        uploaddata();
                    },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 253, 188, 51),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        margin: EdgeInsets.all(10),
                        width: screenWidth*.25,
                        height: screenWidth*.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file),
                            Text("Upload",style: text_style,),
                            Text("Data",style: text_style,),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> addPhoneNumber()async {
    status=await checkUser();
    if(status=="false") {
      return phone
          .add({
        'number': mobile, // John Doe
        'status': "true", // Stokes and Sons
      }).then((value) {
        setState(() {
          loading=!loading;
        });
        showSnackBar("Invited SuccessFully!", context);
        String msg = "I Invited you on Pal Associates app .Please download our app from http://vkwilson.email/";
        openwhatsapp(msg, context);})
          .catchError((error) {
        setState(() {
          loading=!loading;
        });
        print(error.toString());
        return showMyDialog("Error", error.toString(), context);}  );
    }
    else {
      setState(() {
        loading=true;
      });
      String role=status;
      if(status=="true") {
        role="User";
      }
      showSnackBar("User already authorized! as $role", context);
    }
  }
  Future<String>checkUser()async{
    status="false";
    await phone
        .where('number', isEqualTo: mobile)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // print(querySnapshot.toString());
      querySnapshot.docs.forEach((doc) {
        id = doc.id;
        Map<String, dynamic> data =
        doc.data() as Map<String, dynamic>;
        status = data['status'];
        print("this is status ${status}");
        print(id);
      });
    });
    return status;
  }
  checkstatus()async{
    status=await checkUser();
    if (status == "true"||status=="admin") {
      setState(() {
        loading=true;
      });
      String role=status;
      if(status=="true") {
        role="User";
      }
      showSnackBar("This number is authorized as $role", context);
    } else {
      setState(() {
        loading=true;
      });
      String msg="This app is not authorized to use this app\nDo you want to authorized";
      AddUserDialog("Not Authorized",msg,mobile,context);
    }
  }

  void blockUser() async{
    status=await checkUser() ;
    if(status=="true"||status=="admin") {
      phone
          .doc(id)
          .delete()
          .then((value) => showSnackBar("Blocked Successfully", context))
          .catchError((error) =>showSnackBar("Failed to update user: $error", context));
    }
    else {
      showSnackBar("User already Blocked", context);
    }
    setState(() {
      loading=true;
    });
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
  void inviteadmin()async{
    status=await checkUser();
    if(status=="false") {
      return phone
          .add({
        'number': mobile, // John Doe
        'status': "admin", // Stokes and Sons
      }).then((value) {
        setState(() {
          loading=!loading;
        });
        showSnackBar("Invited SuccessFully!", context);
        String msg = "I Invited you on Pal Associates app as Admin.Please download our app from http://vkwilson.email/";
        openwhatsapp(msg, context);})
          .catchError((error) {
        setState(() {
          loading=!loading;
        });
        print(error.toString());
        return showMyDialog("Error", error.toString(), context);}  );
    }
    else {
      setState(() {
        loading=true;
      });
      String role=status;
      if(status=="true") {
        role="User";
      }
      showSnackBar("Number is already authorized! as $role", context);
    }
  }
  void uploaddata(){
    showSnackBar("This option is under development.Contact to development team.", context);
  }

}
