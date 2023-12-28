// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:flutter/cupertino.dart';
// import 'dart:async';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// // import 'package:fluttertoast/fluttertoast.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: MyHomePage(),
// //     );
// //   }
// // }
// //
// // class MyHomePage extends StatefulWidget {
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     checkInternetConnection();
// //   }
// //
// //   Future<void> checkInternetConnection() async {
// //     var connectivityResult = await Connectivity().checkConnectivity();
// //     if (connectivityResult == ConnectivityResult.wifi) {
// //       print('WIFI');
// //       //showInternetWarning();
// //     }
// //   }
// //
// //   void showInternetWarning() {
// //     print('not');
// //     Fluttertoast.showToast(
// //       msg: "No Internet Connection",
// //       toastLength: Toast.LENGTH_LONG,
// //       gravity: ToastGravity.BOTTOM,
// //       timeInSecForIosWeb: 1,
// //       backgroundColor: Colors.red,
// //       textColor: Colors.black,
// //       fontSize: 16.0,
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Internet Connection Checker"),
// //       ),
// //       body: Center(
// //         child: Text("Check the internet connection status."),
// //       ),
// //     );
// //   }
// // }
//
// // class ConnectionChecker extends StatelessWidget {
// //   const ConnectionChecker({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<ConnectivityResult>(
// //         stream: Connectivity().onConnectivityChanged,
// //         builder: (context, snapshot) {
// //           return Scaffold(
// //             appBar: AppBar(
// //               title: const Text('Connection Checker'),
// //             ),
// //             body: Center(
// //               child: snapshot.data == ConnectivityResult.none
// //                   ? const Text('No')
// //                   : const Text('Yes'),
// //             ),
// //           );
// //         });
// //   }
// // }
//
// class ConnectionChecker extends StatefulWidget {
//   const ConnectionChecker({super.key});
//
//   @override
//   State<ConnectionChecker> createState() => _ConnectionCheckerState();
// }
//
// class _ConnectionCheckerState extends State<ConnectionChecker> {
//   late ConnectivityResult result;
//   late StreamSubscription subscription;
//   var isCon = false;
//   @override
//   void initState() {
//     super.initState();
//     startStream();
//   }
//   checkInternet() async {
//     result =await Connectivity().checkConnectivity();
//     if (result != ConnectivityResult.none) {
//       isCon = true;
//     } else {
//       isCon = false;
//       Text('no');
//       showDialogBox();
//     }
//     setState(() {});
//   }
//
//   showDialogBox() {
//     showDialog(
//       barrierDismissible: false,
//         context: context,
//         builder: (context) => CupertinoAlertDialog(
//               title: Text('NO'),
//               content: Text('Check'),
//               actions: [
//                 CupertinoButton.filled(child: Text('Retry'), onPressed: () {
//                   Navigator.pop(context);
//                   checkInternet();
//                 })
//               ],
//             ));
//   }
//   startStream(){
//     subscription=Connectivity().onConnectivityChanged.listen((event) {
//       checkInternet();
//     });
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connectiobn'),
//       ),
//       body: Text('HIiiiii'),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class Demo extends StatefulWidget {
//   @override
//   _DemoState createState() => _DemoState();
// }
//
// class _DemoState extends State<Demo> {
//   DateTime _currentDate = DateTime.now();
//   String _Date(DateTime dateTime) {
//     return DateFormat('dd-MM-yyyy').format(dateTime);
//   }
//   List<Student> _students = [
//     Student(name: 'Student 1'),
//     Student(name: 'Student 2'),
//     Student(name: 'Student 3'),
//     // Add more students as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance App'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               _Date(DateTime.now()),
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _students.length,
//               itemBuilder: (context, index) {
//                 return _buildStudentTile(_students[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStudentTile(Student student) {
//     Color statusColor = student.getAttendanceStatus(_currentDate) == 'Present'
//         ? Colors.green
//         : Colors.red;
//
//     return ListTile(
//       title: Text(student.name),
//       trailing: Icon(Icons.check, color: statusColor),
//       onTap: () {
//         setState(() {
//           student.toggleAttendance(_currentDate);
//         });
//       },
//       subtitle: Text(
//         student.getAttendanceStatus(_currentDate),
//         style: TextStyle(color: statusColor),
//       ),
//     );
//   }
// }
//
// class Student {
//   final String name;
//   List<DateTime> attendanceDates = [];
//
//   Student({required this.name});
//
//   void toggleAttendance(DateTime date) {
//     if (attendanceDates.contains(date)) {
//       attendanceDates.remove(date);
//     } else {
//       attendanceDates.add(date);
//     }
//   }
//
//   String getAttendanceStatus(DateTime date) {
//     return attendanceDates.contains(date) ? 'Present' : 'Absent';
//   }
// }

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  DateTime _currentDate = DateTime.now();
  List<Student> _students = [
    Student(name: 'Student 1'),
    Student(name: 'Student 2'),
    Student(name: 'Student 3'),
    // Add more students as needed
  ];

  List<String> _subjects = ['Math', 'Science', 'History', 'English'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${_currentDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Subject-wise Attendance:'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _subjects.map((subject) {
                    return Text(
                      '$subject: ${_getSubjectAttendanceCount(subject)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return _buildStudentTile(_students[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTile(Student student) {
    return ListTile(
      title: Text(student.name),
      subtitle: Text(_getStudentAttendanceSummary(student)),
    );
  }

  String _getStudentAttendanceSummary(Student student) {
    List<String> subjectAttendance = [];
    for (String subject in _subjects) {
      String status = student.getAttendanceStatus(_currentDate, subject);
      Color statusColor = status == 'Present' ? Colors.green : Colors.red;
      subjectAttendance.add(
        '$subject: ${status.toUpperCase()}',
      );
    }
    return subjectAttendance.join(' | ');
  }

  int _getSubjectAttendanceCount(String subject) {
    int count = 0;
    for (Student student in _students) {
      if (student.getAttendanceStatus(_currentDate, subject) == 'Present') {
        count++;
      }
    }
    return count;
  }
}

class Student {
  final String name;
  Map<String, List<DateTime>> attendanceBySubject = {};

  Student({required this.name});

  void toggleAttendance(DateTime date, String subject) {
    if (attendanceBySubject.containsKey(subject)) {
      if (attendanceBySubject[subject]!.contains(date)) {
        attendanceBySubject[subject]!.remove(date);
      } else {
        attendanceBySubject[subject]!.add(date);
      }
    } else {
      attendanceBySubject[subject] = [date];
    }
  }

  String getAttendanceStatus(DateTime date, String subject) {
    return attendanceBySubject.containsKey(subject) &&
        attendanceBySubject[subject]!.contains(date)
        ? 'Present'
        : 'Absent';
  }
}





