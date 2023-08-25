import 'package:clg_project/dashboard.dart';
import 'package:clg_project/faculty_dashboard.dart';
import 'package:clg_project/login.dart';
import 'package:clg_project/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: faculty_dashboard(),
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff002233),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "eCollege",
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                    Text(
                      "eCollege Serves You Virtual \n Education At Your home",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 5, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: Colors.white)),

                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => login("SP ID"),));
                          },
                          child: Text("LOGIN AS STUDENT",style: TextStyle(color: Colors.white,fontSize: 15),)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => login("Faculty ID"),));
                          },
                          child: Text("LOGIN AS FACULTY",style: TextStyle(color: Color(0xff002233),fontSize: 15),)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
