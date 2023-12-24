// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     checkInternetConnection();
//   }
//
//   Future<void> checkInternetConnection() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.wifi) {
//       print('WIFI');
//       //showInternetWarning();
//     }
//   }
//
//   void showInternetWarning() {
//     print('not');
//     Fluttertoast.showToast(
//       msg: "No Internet Connection",
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.black,
//       fontSize: 16.0,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Internet Connection Checker"),
//       ),
//       body: Center(
//         child: Text("Check the internet connection status."),
//       ),
//     );
//   }
// }

// class ConnectionChecker extends StatelessWidget {
//   const ConnectionChecker({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<ConnectivityResult>(
//         stream: Connectivity().onConnectivityChanged,
//         builder: (context, snapshot) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Connection Checker'),
//             ),
//             body: Center(
//               child: snapshot.data == ConnectivityResult.none
//                   ? const Text('No')
//                   : const Text('Yes'),
//             ),
//           );
//         });
//   }
// }

class ConnectionChecker extends StatefulWidget {
  const ConnectionChecker({super.key});

  @override
  State<ConnectionChecker> createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isCon = false;
  @override
  void initState() {
    super.initState();
    startStream();
  }
  checkInternet() async {
    result =await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isCon = true;
    } else {
      isCon = false;
      Text('no');
      showDialogBox();
    }
    setState(() {});
  }

  showDialogBox() {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('NO'),
              content: Text('Check'),
              actions: [
                CupertinoButton.filled(child: Text('Retry'), onPressed: () {
                  Navigator.pop(context);
                  checkInternet();
                })
              ],
            ));
  }
  startStream(){
    subscription=Connectivity().onConnectivityChanged.listen((event) {
      checkInternet();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectiobn'),
      ),
      body: Text('HIiiiii'),
    );
  }
}
