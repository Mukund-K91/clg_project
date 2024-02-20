import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class Student {
  final String documentId; // Firestore document ID
  final int rollNo;
  final String name;

  Student({
    required this.documentId,
    required this.rollNo,
    required this.name,
  });
}

class AttendanceRecord {
  final String subject;
  int presentCount;
  int absentCount;

  AttendanceRecord({
    required this.subject,
    this.presentCount = 0,
    this.absentCount = 0,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Demo(),
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  List<Student> students = [];
  String selectedSubject = 'Math'; // Default subject
  DateTime selectedDate = DateTime.now();

  List<AttendanceRecord> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot<Map<String, dynamic>> studentsQuery =
        await FirebaseFirestore.instance.collection('students').get();

    students = studentsQuery.docs.map((doc) {
      return Student(
        documentId: doc.id,
        rollNo: doc['Roll No'],
        name: doc['First Name'],
      );
    }).toList();

    // Initialize attendanceRecords with default values
    attendanceRecords = students.map((student) {
      return AttendanceRecord(subject: selectedSubject);
    }).toList();

    setState(() {});
  }

  void _toggleAttendance(int index, bool isPresent) {
    setState(() {
      if (isPresent) {
        attendanceRecords[index].presentCount++;
      } else {
        attendanceRecords[index].absentCount++;
      }
    });
  }

  Future<void> _submitAttendance() async {
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('students');

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (int i = 0; i < students.length; i++) {
      Student student = students[i];

      // Create or update daily attendance subcollection
      DocumentReference studentDocRef =
          studentCollection.doc(student.documentId);

      CollectionReference monthlyAttendanceCollection =
          studentDocRef.collection('monthlyAttendance');

      String date = DateFormat.MMMM().format(selectedDate);
      String dateKey = '${date}';

      DocumentReference dailyAttendanceDocRef =
          monthlyAttendanceCollection.doc(dateKey);

      DocumentSnapshot<Object?> dailyAttendanceDoc =
          await dailyAttendanceDocRef.get();

      if (!dailyAttendanceDoc.exists) {
        // Create new daily attendance record if not exists for the current date
        batch.set(dailyAttendanceDocRef, {
          'subjectAttendance': {
            selectedSubject: {
              'presentCount': 0,
              'absentCount': 0,
            }
          },
        });
      }

      // Update daily attendance count based on the recorded counts
      AttendanceRecord record = attendanceRecords[i];
      batch.update(dailyAttendanceDocRef, {
        'subjectAttendance.$selectedSubject.presentCount':
            FieldValue.increment(record.presentCount),
        'subjectAttendance.$selectedSubject.absentCount':
            FieldValue.increment(record.absentCount),
      });
    }

    // Commit the batch
    await batch.commit();

    // Reset attendanceRecords after submitting
    setState(() {
      attendanceRecords = students.map((student) {
        return AttendanceRecord(subject: selectedSubject);
      }).toList();
    });

    print(
        'Attendance submitted for date: $selectedDate, subject: $selectedSubject');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance App'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedSubject,
            onChanged: (value) {
              setState(() {
                selectedSubject = value!;
                // Reset attendanceRecords when subject changes
                attendanceRecords = students.map((student) {
                  return AttendanceRecord(subject: selectedSubject);
                }).toList();
              });
            },
            items:
                ['Math', 'Science', 'English'] // Add other subjects as needed
                    .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () => _pickDate(context),
            child: Text('Select Date: ${selectedDate.toLocal()}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                Student student = students[index];

                return ListTile(
                  title: Text('${student.name} - Roll No: ${student.rollNo}'),
                  subtitle: Text('Subject: $selectedSubject'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: false,
                        // Placeholder value, replace with actual logic
                        onChanged: (value) =>
                            _toggleAttendance(index, value ?? false),
                      ),
                      Text('Present'),
                      SizedBox(width: 10),
                      Checkbox(
                        value: false,
                        // Placeholder value, replace with actual logic
                        onChanged: (value) =>
                            _toggleAttendance(index, !value! ?? false),
                      ),
                      Text('Absent'),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submitAttendance,
            child: Text('Submit Attendance'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
// import 'package:flutter/material.dart';
//
// /// Flutter code sample for [NavigationBar].
//
// void main() => runApp(const NavigationBarApp());
//
// class NavigationBarApp extends StatelessWidget {
//   const NavigationBarApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: const NavigationExample(),
//     );
//   }
// }
//
// class NavigationExample extends StatefulWidget {
//   const NavigationExample({super.key});
//
//   @override
//   State<NavigationExample> createState() => _NavigationExampleState();
// }
//
// class _NavigationExampleState extends State<NavigationExample> {
//   int currentPageIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return Scaffold(
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             currentPageIndex = index;
//           });
//         },
//         indicatorColor: Colors.amber,
//         selectedIndex: currentPageIndex,
//         destinations: const <Widget>[
//           NavigationDestination(
//             selectedIcon: Icon(Icons.home),
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Badge(child: Icon(Icons.notifications_sharp)),
//             label: 'Notifications',
//           ),
//           NavigationDestination(
//             icon: Badge(
//               label: Text('2'),
//               child: Icon(Icons.messenger_sharp),
//             ),
//             label: 'Messages',
//           ),
//         ],
//       ),
//       body: <Widget>[
//         /// Home page
//         Card(
//           shadowColor: Colors.transparent,
//           margin: const EdgeInsets.all(8.0),
//           child: SizedBox.expand(
//             child: Center(
//               child: Text(
//                 'Home page',
//                 style: theme.textTheme.titleLarge,
//               ),
//             ),
//           ),
//         ),
//
//         /// Notifications page
//         const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             children: <Widget>[
//               Card(
//                 child: ListTile(
//                   leading: Icon(Icons.notifications_sharp),
//                   title: Text('Notification 1'),
//                   subtitle: Text('This is a notification'),
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: Icon(Icons.notifications_sharp),
//                   title: Text('Notification 2'),
//                   subtitle: Text('This is a notification'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         /// Messages page
//         ListView.builder(
//           reverse: true,
//           itemCount: 2,
//           itemBuilder: (BuildContext context, int index) {
//             if (index == 0) {
//               return Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   margin: const EdgeInsets.all(8.0),
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.primary,
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Text(
//                     'Hello',
//                     style: theme.textTheme.bodyLarge!
//                         .copyWith(color: theme.colorScheme.onPrimary),
//                   ),
//                 ),
//               );
//             }
//             return Align(
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 margin: const EdgeInsets.all(8.0),
//                 padding: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.primary,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Text(
//                   'Hi!',
//                   style: theme.textTheme.bodyLarge!
//                       .copyWith(color: theme.colorScheme.onPrimary),
//                 ),
//               ),
//             );
//           },
//         ),
//       ][currentPageIndex],
//     );
//   }
// }

