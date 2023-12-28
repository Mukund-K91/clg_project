import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<Map<String, dynamic>> studentList = [];
  String selectedDivision = 'Div';
  final _divison = ["Div", "A", "B", "C", "D"];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch data from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('students').get();

    // Convert QuerySnapshot to List
    List<Map<String, dynamic>> allStudents = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      return doc.data();
    }).toList();

    // Filter and sort the data based on the selected division and roll number
    setState(() {
      studentList = allStudents.where((student) => student['Div'] == selectedDivision).toList();
      studentList.sort((a, b) => a['Roll No'].compareTo(b['Roll No']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List by Division and Roll No'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            DropdownButtonFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder()),
                value: selectedDivision,
                items: _divison
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedDivision = val as String;
                    fetchData();
                  });
                }),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




