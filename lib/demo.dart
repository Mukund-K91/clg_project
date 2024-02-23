import 'package:clg_project/noticeboard.dart';
import 'package:clg_project/reusable_widget/bottom_navigationbar.dart';
import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:clg_project/student/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'admin/Material.dart';
import 'admin/PageNotAvailable.dart';
import 'admin/admin.dart';
import 'admin/assignment.dart';
import 'admin/attendance.dart';
import 'admin/faculty_dashboard.dart';
import 'main.dart';

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

class Myhome extends StatefulWidget {
  String email;
  String _user;

  Myhome(this.email, this._user,{super.key});

  @override
  State<StatefulWidget> createState() {
    return myhomestate();
  }
}

class myhomestate extends State<Myhome> {
  // this selected index is control the bottom navigator bar
  int _selectedindex = 0;

  // this method will update your selected index
  // when the user tap on bottom bar
  void navigatorbottombar(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  // pages to display
  final List<Widget> _pages = [
    // shop page
    FacultyDashboard('admin2@gmail.com', 'Faculty'),
    NoticeBoard('Dimple'+'Patel', 'Faculty'),
    const AssignmentPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Mybottomnav(
        onTabChange: (index) => navigatorbottombar(index),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchDataByEmail(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Error: ${snapshot.error} USER NOT FOUND\nplease contact your administrator eCollegeAdmin@gmail.com'),
                Reusablebutton(
                  Style: true,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeMain(),
                        ));
                  },
                  child: const Text('Return Home Page'),
                )
              ],
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('No data found for the given email.');
          } else {
            // Data found, you can access it using snapshot.data
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            return Stack(
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      color: Color(0xff002233),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //_pages[_selectedindex],
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: Card(
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  foregroundImage:
                                  AssetImage("assets/images/ex_img.png"),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data['First Name'] +
                                          " " +
                                          data['Last Name'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      data['Department'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentManage(),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(
                                    FontAwesomeIcons.userGraduate,
                                    color: Color(0xff002233),
                                  ),
                                ),
                                const Text(
                                  "Students",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Attendance(),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.calendarDay,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Attendance",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await pagenotfound(context,
                                        'This Feature Not available Yet...!\nunder progress');
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.filePen,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Assignment",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  iconSize: 50,
                                  icon: const Icon(
                                      FontAwesomeIcons.fileContract,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Results",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FilesUpload(widget._user),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.book,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Material",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    String name =
                                        data['First Name'] + data['Last Name'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NoticeBoard(name, widget._user),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.newspaper,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Notice & Events",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}
Future<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchDataByEmail(
    String email) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    Future<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot =
    firestore
        .collection('faculty')
        .where('Email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot
            .docs[0]; // Assuming there's only one matching document
      } else {
        throw Exception('No document found with the given email.');
      }
    });

    return documentSnapshot;
  } catch (e) {
    print('Error fetching data: $e');
    return null;
  }
}
