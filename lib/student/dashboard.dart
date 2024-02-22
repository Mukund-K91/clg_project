import 'package:clg_project/admin/faculty_dashboard.dart';
import 'package:clg_project/main.dart';
import 'package:clg_project/student/profile.dart';
import 'package:clg_project/student/student_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class MainDashboard extends StatelessWidget {
  final String user;
  var email;
  MainDashboard(this.user, this.email, {super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print(email);
    return Scaffold(
        appBar: AppBar(
          leading: user == "Student"
              ? IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.user,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(email),
                        ));
                  },
                )
              : const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                ),
          actions: [
            user == 'Faculty'
                ? IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeMain(),
                          ));
                      runApp(MaterialApp(
                        home: const HomeMain(),
                        color: const Color(0xff002233),
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                              seedColor: const Color(0xff002233)),
                          useMaterial3: true,
                        ),
                      ));
                    },
                    icon: const Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ))
                : const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
          ],
          title: const Text(
            "DASHBOARD",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff002233),
        ),
        body: user == "Student"
            ? StudentDashboard(email, user)
            : FacultyDashboard(email, user));
  }
}
