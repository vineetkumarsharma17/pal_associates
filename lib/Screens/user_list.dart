import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pal_associates/component/alertdilog.dart';
import 'package:pal_associates/component/drawer.dart';
import 'package:pal_associates/component/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class User_List extends StatefulWidget {
  const User_List({Key key}) : super(key: key);

  @override
  State<User_List> createState() => _User_ListState();
}

class _User_ListState extends State<User_List> {
  List data = [];
  bool loading = true;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  Future getDocs() async {
    QuerySnapshot querySnapshot = await phone.get().then((querySnapshot) {
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        data = allData;
        loading = true;
      });
      log(data.toString());
      return querySnapshot;
    }).catchError((e) {
      log(e.toString());
      showSnackBar(e.toString(), context);
      setState(() {
        loading = true;
      });
    });

    // Get data from docs and convert map to List
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocs();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text("Pal Associates"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                  onPressed: () => showExitDialog(
                      "Alert!", "Are you sure to exit?", context),
                  icon: Icon(Icons.logout))),
        ],
        // automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
      body: loading
          ? Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Map detail = data[index];
                    return Card(
                      //color: Colors.w,
                      child: Padding(
                        padding: EdgeInsets.all(5),
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
                                                color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          width: width * .02,
                                          child: const Text(
                                            ":",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          width: width * .35,
                                          child: Text(
                                            "${detail[key]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        key == "number"
                                            ? IconButton(
                                                onPressed: () {
                                                  launchCaller(detail[key]);
                                                },
                                                icon: Icon(Icons.call))
                                            : SizedBox()
                                      ],
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    );
                  }))
          : Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }

  launchCaller(String num) async {
    String url = "tel:$num";
    log(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
