import 'package:clg_project/drawer_menu.dart';
import 'package:clg_project/faculty_dashboard.dart';
import 'package:clg_project/profile.dart';
import 'package:clg_project/student_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatelessWidget {
  final String user;
  var email;

  Dashboard(this.user, this.email, {super.key});

  @override
  Widget build(BuildContext context) {
    print(email);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.user,color: Colors.white,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(email),));
            },
          ),
          title: Text(
            "DASHBOARD",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff002233),
        ),
        body: user == "student"
            ? StudentDashboard(email)
            : const FacultyDashboard());
  }
}
