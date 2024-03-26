import 'package:clg_project/event_screen.dart';
import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:clg_project/splash_screen.dart';
import 'package:clg_project/student/Studentassignment.dart';
import 'package:clg_project/student/dashboard.dart';
import 'package:clg_project/student/login.dart';
import 'package:clg_project/student/student_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin/assignment.dart';

import 'admin/faculty_dashboard.dart';
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
        title: 'eCollege',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff002233)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}

