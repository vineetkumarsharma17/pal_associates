import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pal_associates/component/alertdilog.dart';
import 'package:pal_associates/component/component.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/share_to_whatsapp.dart';
import 'package:pal_associates/component/snack_bar.dart';

class AdminSearchScreen extends StatefulWidget {
  const AdminSearchScreen({Key key}) : super(key: key);

  @override
  _AdminSearchScreenState createState() => _AdminSearchScreenState();
}

class _AdminSearchScreenState extends State<AdminSearchScreen> {
  String query = '';
  bool loading = true;
  List data = [];
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
        .post(Uri.parse("http://vkwilson.email/getdataadmin.php"),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pal Associates"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                  onPressed: () => showExitDialog(
                      "Alert!", "Are you sure to exit?", context),
                  icon: const Icon(Icons.logout))),
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
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
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
                    loading
                        ? Container(
                            margin: const EdgeInsets.all(8),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    controller: rc_number,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter 4 digits ie.1234',
                                      border: InputBorder.none,
                                      // enabledBorder: InputBorder.none,
                                      // focusedBorder: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 13.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.yellow,
                            backgroundColor: Colors.teal,
                            strokeWidth: 5,
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (validate()) {
                          setState(() {
                            loading = !loading;
                          });
                          search();
                        }
                        // setState(() {
                        //   dataget = !dataget;
                        // });
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
              ),
              dataget
                  ? const Text("")
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String msg = '';
                        for (var x in data[index].keys) {
                          msg += x.toString() +
                              ": " +
                              data[index][x].toString() +
                              "\n";
                        }
                        double width = MediaQuery.of(context).size.width - 6;
                        Map detail = data[index];
                        return Card(
                            color: Colors.teal,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: detail.length,
                                      itemBuilder: (context, i) {
                                        String key = detail.keys.elementAt(i);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 3),
                                                width: width * .35,
                                                child: Text(
                                                  "$key",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 3),
                                                width: width * .02,
                                                child: const Text(
                                                  ":",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 3),
                                                width: width * .45,
                                                child: Text(
                                                  "${detail[key]}",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            log(msg);
                                            openwhatsapp(msg, context);
                                          },
                                          icon: const Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            Clipboard.setData(
                                                ClipboardData(text: msg));
                                            showSnackBar(
                                                "Text Coppied!", context);
                                          },
                                          icon: const Icon(
                                            Icons.copy,
                                            color: Colors.white,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ));
                      }),
            ],
          ),
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
