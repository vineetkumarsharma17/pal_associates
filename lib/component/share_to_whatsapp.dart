import 'package:share_plus/share_plus.dart';
openwhatsapp(String msg,context) async{
  await Share.share(msg);

  // // var whatsapp = "+919369640153";
  // var whatsappURl_android = "whatsapp://send?&text=$msg";
  //  showDialog<void>(
  //   context: context,
  //   barrierDismissible: false, // user must tap button!
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: Text("Open  Whatsapp"),
  //       content: Text("Do you want share on whatsapp ?"),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('No'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         TextButton(
  //           child: const Text('Yes'),
  //           onPressed: () async {
  //             if (await canLaunch(whatsappURl_android)) {
  //               await launch(whatsappURl_android);
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: new Text("whatsapp no installed")));
  //             }
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     );
  //   },
  // );
}