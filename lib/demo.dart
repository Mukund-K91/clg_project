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

