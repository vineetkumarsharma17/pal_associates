import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pal_associates/component/alertdilog.dart';
import 'package:pal_associates/component/component.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/snack_bar.dart';
class UserScreenHome extends StatefulWidget {
  const UserScreenHome({Key? key}) : super(key: key);

  @override
  _UserScreenHomeState createState() => _UserScreenHomeState();
}

class _UserScreenHomeState extends State<UserScreenHome> {
  String query='';
  bool loading=true;
  var cquery=TextEditingController();
  search()async{
    setState(() {
      loading=false;
    });
    query=cquery.text;
    var data = {
      "data": query,
    };
    var response = await http.post(
        Uri.parse(
            "http://vkwilson.email/getdata.php"),
        body: json.encode(data)).catchError((e){
      setState(() {
        loading=true;
      });
      if(e is SocketException)
        return showSnackBar("No internet connection", context);
    });
    var obj = jsonDecode(response.body);
    if(obj["status"]==1){
      Map tmp=obj["data"];
      print("Data========================");
      String detail='';
      for( var x in tmp.keys) {
        detail=detail+"$x=${tmp[x]}\n";
        // print("$x=${tmp[x]}");

      }
      showDataDialog("Data Found!",detail,context);
      // print(detail);
    }
    else{
      showSnackBar("No data found", context);
    }
    setState(() {
      cquery.clear();
      loading=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pal Associations"),
        actions:  [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child:IconButton(
                onPressed: ()=>showExitDialog("Alert!", "Are you sure to exit?", context),
                icon: const Icon(Icons.logout))
          ),
        ],
        // automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Image.asset(
                'assets/images/registration.png',
                height: screenHeight * 0.18,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              const Text(
                'Welcome User! ',
                style: TextStyle(
                  fontSize: 33,
                  color: Colors.teal,
                  fontFamily: "Pacifico",
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
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
                              controller: cquery,
                              decoration: const InputDecoration(
                                hintText: 'Vehicle Number',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 13.5),
                              ),
                              onChanged: (value){
                                setState(() {
                                  query=value;
                                });
                              },
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

                      if(validate())  {
                        setState(() {
                          loading=!loading;
                        });
                          search();
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
                          'Search',
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
    query=cquery.text;
    if(query.isEmpty) {
      showSnackBar("Please insert Data", context);
      return false;
    }
    return true;
  }
}
