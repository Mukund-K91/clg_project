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
  List<int> clickCounts = [];

  @override
  void initState() {
    super.initState();
    _initializeClickCounts();
    fetchData();
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
    switch (clickCounts[index]) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  String _getButtonText(int index) {
    switch (clickCounts[index]) {
      case 1:
        return 'Present';
      case 2:
        return 'Absent';
      default:
        return 'Take';
    }
  }

  void _initializeClickCounts() {
    // Fetch the total number of students and set initial clickCounts
    FirebaseFirestore.instance
        .collection('students')
        .get()
        .then((querySnapshot) {
      setState(() {
        clickCounts = List.generate(querySnapshot.size, (index) => 0);
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: selectedDivision,
                items: _divison
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _resetButtonColor();
                    selectedDivision = val!;
                    fetchData();
                  });
                }),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: studentList.length,
                  itemBuilder: (context, index) {
                    var student = studentList[index];
                    return Card(
                      color: const Color(0xff002233),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 17,
                          backgroundColor: const Color(0xffffffff),
                          child: Text(
                            student['Div'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        title: InkWell(
                          child: Text(
                            student['Roll No'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        subtitle: Text(
                          student['First Name'] + " " + student['Last Name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              maximumSize: Size(100, 40),
                              minimumSize: Size(100, 40),
                              primary: _getButtonColor(index)),
                          onPressed: () {
                            _changeColorAndText(index);
                          },
                          child: Text(
                            _getButtonText(index),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  })),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: const Color(0xff002233),
                ),
                onPressed: (){
                  _resetButtonColor();
                },
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
