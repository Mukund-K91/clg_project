import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentResultPage extends StatefulWidget {
  final String userId;
  final String program;
  final String programterm;
  final String division;

  StudentResultPage({
    required this.userId,
    required this.program,
    required this.programterm,
    required this.division,
  });

  @override
  _StudentResultPageState createState() => _StudentResultPageState();
}

class _StudentResultPageState extends State<StudentResultPage> {
  Map<String, Map<String, int>> subjectMarks = {};
  String selectedExamType = "--Please Select--";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    try {
      setState(() {
        isLoading = true;
      });

      DocumentSnapshot<Map<String, dynamic>> resultSnapshot =
      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.program)
          .collection(widget.programterm)
          .doc(widget.division)
          .collection('student')
          .doc(widget.userId)
          .collection('result')
          .doc('23-24')
          .get();

      Map<String, dynamic> resultData = resultSnapshot.data() ?? {};

      // Clear existing marks
      subjectMarks.clear();

      // Fetch marks for the selected exam type
      if (resultData.containsKey(selectedExamType)) {
        Map<String, dynamic> examTypeMarks = resultData[selectedExamType];
        examTypeMarks.forEach((subject, marksData) {
          int obtainMarks = marksData['obtainmarks'] ?? 0;
          int totalMarks = marksData['totalmarks'] ?? 0;
          subjectMarks[subject] = {
            'obtainMarks': obtainMarks,
            'totalMarks': totalMarks
          };
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching student data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internal Marks Details'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              "Component Type",
              style: TextStyle(fontSize: 15),
            ),
            subtitle: DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero))),
                value: selectedExamType,
                items: [
                  '--Please Select--',
                  'Internal',
                  'Practical-Internal'
                ]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedExamType = val as String;
                    fetchStudentData();
                  });
                }),
          ),

          SingleChildScrollView(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : subjectMarks.isNotEmpty
                    ? Column(
                        children: subjectMarks.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              child: ListTile(
                                title: Text("${entry.key}"),
                                subtitle:
                                    Text("Out of ${entry.value['totalMarks']}"),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff002233),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 70,
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      "${entry.value['obtainMarks']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Text(
                        "No result found for this student.",
                        style: TextStyle(fontSize: 16),
                      ),
          ),
        ],
      ),
    );
  }
}
