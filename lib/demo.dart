//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class Student {
//   final String documentId; // Firestore document ID
//   final int rollNo;
//   final String name;
//
//   Student({
//     required this.documentId,
//     required this.rollNo,
//     required this.name,
//   });
// }
//
// class AttendanceRecord {
//   final String subject;
//   int presentCount;
//   int absentCount;
//
//   AttendanceRecord({
//     required this.subject,
//     this.presentCount = 0,
//     this.absentCount = 0,
//   });
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Demo(),
//     );
//   }
// }
//
// class Demo extends StatefulWidget {
//   @override
//   _DemoState createState() => _DemoState();
// }
//
// class _DemoState extends State<Demo> {
//   List<Student> students = [];
//   String selectedSubject = 'Math'; // Default subject
//   DateTime selectedDate = DateTime.now();
//   List<AttendanceRecord> attendanceRecords = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     QuerySnapshot<Map<String, dynamic>> studentsQuery =
//     await FirebaseFirestore.instance.collection('students').get();
//
//     students = studentsQuery.docs.map((doc) {
//       return Student(
//         documentId: doc.id,
//         rollNo: doc['Roll No'],
//         name: doc['First Name'],
//       );
//     }).toList();
//
//     // Initialize attendanceRecords with default values
//     attendanceRecords = students.map((student) {
//       return AttendanceRecord(subject: selectedSubject);
//     }).toList();
//
//     setState(() {});
//   }
//
//   void _toggleAttendance(int index, bool isPresent) {
//     setState(() {
//       if (isPresent) {
//         attendanceRecords[index].presentCount++;
//       } else {
//         attendanceRecords[index].absentCount++;
//       }
//     });
//   }
//
//   Future<void> _submitAttendance() async {
//     CollectionReference studentCollection =
//     FirebaseFirestore.instance.collection('students');
//
//     WriteBatch batch = FirebaseFirestore.instance.batch();
//
//     for (int i = 0; i < students.length; i++) {
//       Student student = students[i];
//
//       // Create or update daily attendance subcollection
//       DocumentReference studentDocRef =
//       studentCollection.doc(student.documentId);
//
//       CollectionReference monthlyAttendanceCollection =
//       studentDocRef.collection('monthlyAttendance');
//
//       String dateKey =
//           '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
//
//       DocumentReference dailyAttendanceDocRef =
//       monthlyAttendanceCollection.doc(dateKey);
//
//       DocumentSnapshot<Object?> dailyAttendanceDoc =
//       await dailyAttendanceDocRef.get();
//
//       if (!dailyAttendanceDoc.exists) {
//         // Create new daily attendance record if not exists for the current date
//         batch.set(dailyAttendanceDocRef, {
//           'date': selectedDate,
//           'subjectAttendance': {
//             selectedSubject: {
//               'presentCount': 0,
//               'absentCount': 0,
//             }
//           },
//         });
//       }
//
//       // Update daily attendance count based on the recorded counts
//       AttendanceRecord record = attendanceRecords[i];
//       batch.update(dailyAttendanceDocRef, {
//         'subjectAttendance.$selectedSubject.presentCount':
//         FieldValue.increment(record.presentCount),
//         'subjectAttendance.$selectedSubject.absentCount':
//         FieldValue.increment(record.absentCount),
//       });
//     }
//
//     // Commit the batch
//     await batch.commit();
//
//     // Reset attendanceRecords after submitting
//     setState(() {
//       attendanceRecords = students.map((student) {
//         return AttendanceRecord(subject: selectedSubject);
//       }).toList();
//     });
//
//     print('Attendance submitted for date: $selectedDate, subject: $selectedSubject');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance App'),
//       ),
//       body: Column(
//         children: [
//           DropdownButton<String>(
//             value: selectedSubject,
//             onChanged: (value) {
//               setState(() {
//                 selectedSubject = value!;
//                 // Reset attendanceRecords when subject changes
//                 attendanceRecords = students.map((student) {
//                   return AttendanceRecord(subject: selectedSubject);
//                 }).toList();
//               });
//             },
//             items: ['Math', 'Science', 'English'] // Add other subjects as needed
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//           ElevatedButton(
//             onPressed: () => _pickDate(context),
//             child: Text('Select Date: ${selectedDate.toLocal()}'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: students.length,
//               itemBuilder: (context, index) {
//                 Student student = students[index];
//
//                 return ListTile(
//                   title: Text('${student.name} - Roll No: ${student.rollNo}'),
//                   subtitle: Text('Subject: $selectedSubject'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Checkbox(
//                         value: false, // Placeholder value, replace with actual logic
//                         onChanged: (value) =>
//                             _toggleAttendance(index, value ?? false),
//                       ),
//                       Text('Present'),
//                       SizedBox(width: 10),
//                       Checkbox(
//                         value: false, // Placeholder value, replace with actual logic
//                         onChanged: (value) =>
//                             _toggleAttendance(index, !value! ?? false),
//                       ),
//                       Text('Absent'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _submitAttendance,
//             child: Text('Submit Attendance'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
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
  List<Map<String, dynamic>> studentList = [];
  String selectedDivision = 'A';
  List<int> clickCounts = [0];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch data from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('students').get();

    // Convert QuerySnapshot to List
    List<Map<String, dynamic>> allStudents = querySnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      return doc.data();
    }).toList();

    // Filter and sort the data based on the selected division and roll number
    setState(() {
      studentList = allStudents
          .where((student) => student['Div'] == selectedDivision)
          .toList();
      studentList.sort((a, b) => a['Roll No'].compareTo(b['Roll No']));
    });
  }

  void _changeColorAndText(int index) {
    setState(() {
      studentList[index]['clickCounts'] = (
      studentList[index],
      clickCounts[index] = (clickCounts[index] + 1) % 3
      );
    });
  }

  void _resetButtonColor() {
    setState(() {
      studentList.forEach((student) {
        student['clickCount'] = 0;
      });
    });
  }

  Color _getButtonColor(int index) {
    switch (studentList[index]['clickCount']) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  String _getButtonText(int index) {
    switch (studentList[index]['clickCount']) {
      case 1:
        return 'Red Button';
      case 2:
        return 'Green Button';
      default:
        return 'Click me';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List by Division and Roll No'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedDivision,
            onChanged: (value) {
              setState(() {
                selectedDivision = value!;
                _resetButtonColor(); // Reset button color when changing division
                fetchData(); // Fetch and update data when the division changes
              });
            },
            items: ['A', 'B', 'C'] // Add other divisions as needed
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('Division $value'),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                var student = studentList[index];
                var name = student['First Name'];
                var rollNo = student['Roll No'];

                return ListTile(
                  title: Text('$name - Roll No: $rollNo'),
                  trailing: ElevatedButton(
                    onPressed: () => _changeColorAndText(index),
                    style: ElevatedButton.styleFrom(
                      primary: _getButtonColor(index),
                    ),
                    child: Text(_getButtonText(index)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
