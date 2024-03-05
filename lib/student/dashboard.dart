import 'package:clg_project/admin/assignment.dart';
import 'package:clg_project/admin/faculty_dashboard.dart';
import 'package:clg_project/main.dart';
import 'package:clg_project/student/profile.dart';
import 'package:clg_project/student/student_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDashboard extends StatefulWidget {
  final String user;
  var UserId;

  MainDashboard(this.user, this.UserId, {super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.UserId);
    return Scaffold(
      appBar: AppBar(
        leading: widget.user == "Student"
            ? IconButton(
                icon: const Icon(
                  FontAwesomeIcons.user,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(widget.UserId),
                      ));
                },
              )
            : const Icon(
                Icons.account_balance,
                color: Colors.white,
              ),
        actions: [
          widget.user == 'Faculty'
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
        shape: ContinuousRectangleBorder(),
      ),
      body:_getScreen(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff002233),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignment Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return widget.user=="Student"?StudentDashboard(widget.UserId, widget.user):FacultyDashboard(widget.UserId, widget.user);
      case 1:
        return AssignmentPage();
      case 2:
        return SettingsBottomSheet();
      default:
        return widget.user=="Student"?StudentDashboard(widget.UserId, widget.user):FacultyDashboard(widget.UserId, widget.user);
    }
  }
}
class SettingsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Handle language settings
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Handle notification settings
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account'),
            onTap: () {
              // Handle account settings
            },
          ),
        ],
      ),
    );
  }
}