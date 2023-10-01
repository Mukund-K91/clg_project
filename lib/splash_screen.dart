import 'dart:async';

import 'package:clg_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeMain(),
          ));
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/logo.png")),
            const SizedBox(height: 15,),
            LoadingAnimationWidget.discreteCircle(
              color: Colors.black,
              secondRingColor: Color(0xff002233),
              thirdRingColor: Colors.grey,
              size: 50,
            ),],
        ),
      )
    );
  }
}
