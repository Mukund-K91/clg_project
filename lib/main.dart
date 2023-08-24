import 'package:clg_project/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff002233)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:home_main(),
    );
  }
}
class home_main extends StatelessWidget {
  const home_main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage("assets/images/home_screen.png"),
            ),
          ),
        ],
      ),
    );
  }
}
