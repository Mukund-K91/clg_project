import 'dart:async';
import 'dart:io';
import 'package:clg_project/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    // Timer(Duration(seconds: 5), () {
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => HomeMain(),
    //       ));
    // });
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialogBox();
    } else {
      await Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeMain()),
      );
    }
  }

  showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('NO INTERNET'),
              content: Text('PLease check your Internet connection'),
              actions: [
                CupertinoButton.filled(
                    child: Text('Retry'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ));
                      runApp(MaterialApp(
                        home: SplashScreen(),
                        color: const Color(0xff002233),
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                              seedColor: const Color(0xff002233)),
                          useMaterial3: true,
                        ),
                      ));
                    })
              ],
            ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage("assets/images/logo.png")),
          const SizedBox(
            height: 15,
          ),
          LoadingAnimationWidget.discreteCircle(
            color: Colors.black,
            secondRingColor: Color(0xff002233),
            thirdRingColor: Colors.grey,
            size: 50,
          ),
        ],
      ),
    ));
  }
}
