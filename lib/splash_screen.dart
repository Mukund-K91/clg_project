import 'dart:async';

import 'package:clg_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
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
              size: 50,
            ),],
        ),
      )
    );
  }
}
