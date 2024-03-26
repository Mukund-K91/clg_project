import 'dart:async';
import 'package:clg_project/main.dart';
import 'package:clg_project/student/dashboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYLOGIN = "login";
  static const String KEYUSERNAME = 'username';
  static const String KEYUSERTYPE = 'Student';


  @override
  void initState() {
    super.initState();
    _checkInternetConnection();


  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialogBox();
    } else {
      whereToGo();
    }
  }

  showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('NO INTERNET'),
              content: const Text('PLease check your Internet connection'),
              actions: [
                CupertinoButton.filled(
                    child: const Text('Retry'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),(_)=>false
                      );
                      runApp(
                        MaterialApp(
                          home: const SplashScreen(),
                          color: const Color(0xff002233),
                          debugShowCheckedModeBanner: false,
                          theme: ThemeData(
                            colorScheme: ColorScheme.fromSeed(
                              seedColor: const Color(0xff002233),
                            ),
                            useMaterial3: true,
                          ),
                        ),
                      );
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/images/logo.png")),
            const SizedBox(
              height: 15,
            ),
            LoadingAnimationWidget.discreteCircle(
              color: Colors.black,
              secondRingColor: const Color(0xff002233),
              thirdRingColor: Colors.grey,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(KEYLOGIN) ?? false;
    String UserType;
    Timer(Duration(seconds: 3), () {

        if(isLoggedIn){
          var username = sharedPref.getString(KEYUSERNAME);
          var usertype=sharedPref.getString(KEYUSERTYPE);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainDashboard(KEYUSERTYPE, username),
              ),(route)=>false);
        }
        else {
          print("User Logout");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeMain(),
              ),(_)=>false);
        }


    });
  }
}
