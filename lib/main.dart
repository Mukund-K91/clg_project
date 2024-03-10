import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:clg_project/splash_screen.dart';
import 'package:clg_project/student/Studentassignment.dart';
import 'package:clg_project/student/dashboard.dart';
import 'package:clg_project/student/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin/assignment.dart';

import 'demo.dart';

//DONE
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff002233)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home:
            //Demo()
            //Attendance()
           // Studentassignment()
        //HomeMain()
      //SplashScreen()
      MainDashboard('Student', '202400101')
        // Myhome()
        //FacultyDashboard('admin2@gmail.com', 'Faculty')
        //MainDashboard('Student', '202400101')
        //StudentDashboard('202400101', 'Student')
        );
  }
}

class HomeMain extends StatelessWidget {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Image(
            image: AssetImage("assets/images/home_screen.png"),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xff002233),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "eCollege",
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                    const Text(
                      "eCollege Serves You Virtual Education At Your home",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 5, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Reusablebutton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login("Student"),
                              ));
                        },
                        Style: false,
                        child: const Text(
                          "LOGIN AS STUDENT",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Reusablebutton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login("Faculty"),
                              ));
                        },
                        Style: true,
                        child: const Text(
                          "LOGIN AS FACULTY",
                          style:
                              TextStyle(color: Color(0xff002233), fontSize: 15),
                        ),
                      ),
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
