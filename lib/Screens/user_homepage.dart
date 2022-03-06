import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_associates/component/constrainst.dart';
import 'package:pal_associates/component/share_to_whatsapp.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:http/http.dart' as http;

class UserScreenHome extends StatefulWidget {
  const UserScreenHome({Key key}) : super(key: key);

  @override
  State<UserScreenHome> createState() => _UserScreenHomeState();
}

class _UserScreenHomeState extends State<UserScreenHome> {
  String query = '';
  bool loading = true;
  List data = [
    "UP32HJ8978",
    "UP32HJ8978",
    "UP32HJ8978",
    "UP32HJ8978",
    "UP32HJ8978"
  ];
  bool dataget = true;
  var rc_number = TextEditingController();
  // List data = [];
  search() async {
    setState(() {
      dataget = true;
      loading = false;
    });
    query = rc_number.text;
    var prm = {
      "data": query,
    };
    var response = await http
        .post(Uri.parse("http://vkwilson.email/getdata.php"),
            body: json.encode(prm))
        .timeout(const Duration(seconds: 34), onTimeout: () {
      showSnackBar("Time out", context);
      setState(() {
        loading = true;
      });
      throw ("Error");
    }).catchError((e) {
      setState(() {
        loading = true;
      });
      if (e is SocketException)
        return showSnackBar("No internet connection", context);
    });
    try {
      log("Runnning===========");
      var obj = jsonDecode(response.body);

      if (obj["status"] == 1) {
        setState(() {
          dataget = false;
          data = obj["data"];
          log(data.toString());
          // log(data.toString());
          loading = true;
        });
      } else {
        setState(() {
          loading = true;
          rc_number.clear();
        });
        showSnackBar("No data found", context);
      }
    } catch (e) {
      setState(() {
        loading = true;
      });
      if (e is FormatException) {
        print(e.toString());
        showSnackBar("Server Error.", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 550,
              color: Colors.yellow,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/highway.jpg"),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  // main Container for login and Signup
                  Positioned(
                    top: 200,
                    child: Container(
                      height: 280,
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
                              "Hello ! User",
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal),
                            ),
                          ),
                          SizedBox(height: 40),
                          TextField(
                            controller: rc_number,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Palette.iconColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Palette.textColor1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Palette.textColor1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35.0)),
                              ),
                              contentPadding: EdgeInsets.all(20),
                              hintText: "Enter 4 digit ie:1234",
                              hintStyle: TextStyle(
                                  fontSize: 16, color: Palette.textColor1),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Trick to add the submit button
                  Positioned(
                    top: 435,
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
                            setState(() {
                              //loading = !loading;
                              dataget = !dataget;
                            });
                            // if (validate()) {
                            //   setState(() {
                            //     //loading = !loading;
                            //     dataget = !dataget;
                            //   });
                            //   search();
                            // }
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => Profile()));
                          },
                          child: Container(
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
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            dataget
                ? const Text("")
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: data[index].toString()));
                            showSnackBar("Text Coppied!", context);
                          },
                          leading: Icon(Icons.star),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.share),
                          ),
                          title: Text(data[index].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)));
                    }),
          ],
        ),
      ),
    );
  }

  bool validate() {
    query = rc_number.text;
    if (query.isEmpty) {
      showSnackBar("Please insert Data", context);
      return false;
    } else if (query.length < 4) {
      showSnackBar("Please insert 4 digits", context);
      return false;
    }
    return true;
  }
}
