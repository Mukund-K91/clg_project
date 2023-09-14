import 'package:clg_project/drawer_menu.dart';
import 'package:clg_project/faculty_dashboard.dart';
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
          leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  FontAwesomeIcons.bars,
                  color: Colors.white,
                )),
          ),
          title: Text(
            email,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff002233),
        ),
        drawer: Drawer(
          child: Drawer_code(user, email),
        ),
        body: user == "student" ? const StudentDashboard() : const FacultyDashboard());
  }
}
