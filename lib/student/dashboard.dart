import 'package:clg_project/admin/faculty_dashboard.dart';
import 'package:clg_project/event_screen.dart';
import 'package:clg_project/student/student_dashboard.dart';
import 'package:flutter/material.dart';


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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventList(),
                      ));
                },
                icon: const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                )),
          )
        ],
        backgroundColor: const Color(0xff002233),
        shape: const ContinuousRectangleBorder(),
      ),
      body: widget.user == "Student" ? StudentDashboard(
          widget.UserId, widget.user) : FacultyDashboard(
          widget.UserId, widget.user)
      ,
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color(0xff002233),
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.grey[400],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.assignment),
      //       label: 'Assignment Screen',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
    );
  }
}
//   Widget _getScreen(int index) {
//     switch (index) {
//       case 0:
//         return widget.user == "Student" ? StudentDashboard(
//             widget.UserId, widget.user) : FacultyDashboard(
//             widget.UserId, widget.user);
//       case 1:
//         return widget.user == "Student"
//             ? Studentassignment()
//             : AssignmentPage();
//       case 2:
//         return SettingsBottomSheet();
//       default:
//         return widget.user == "Student" ? StudentDashboard(
//             widget.UserId, widget.user) : FacultyDashboard(
//             widget.UserId, widget.user);
//     }
//   }
// }
//
// class SettingsBottomSheet extends StatelessWidget {
//   const SettingsBottomSheet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           ListTile(
//             leading: Icon(Icons.language),
//             title: Text('Language'),
//             onTap: () {
//               // Handle language settings
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text('Notifications'),
//             onTap: () {
//               // Handle notification settings
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.account_circle),
//             title: Text('Account'),
//             onTap: () {
//               // Handle account settings
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }