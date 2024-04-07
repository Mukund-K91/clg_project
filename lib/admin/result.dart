import 'package:clg_project/reusable_widget/lists.dart';
import 'package:clg_project/reusable_widget/reusable_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String userId;
  final String rollNo;
  final String firstName;
  final String lastName;
  final String middleName;
  int totalMarks = 0;
  int obtainMarks = 0;

  Student({
    required this.userId,
    required this.rollNo,
    required this.firstName,
    required this.lastName,
    required this.middleName,
  });

  bool isPass() {
    double thirtyThreePercentOfTotalMarks = totalMarks * 0.40;
    return obtainMarks >= thirtyThreePercentOfTotalMarks;
  }
}

class AllStudentResultTable extends StatefulWidget {
  final String program;
  AllStudentResultTable({required this.program});
  @override
  _AllStudentResultTableState createState() => _AllStudentResultTableState();
}

class _AllStudentResultTableState extends State<AllStudentResultTable> {
  String selectedProgramTerm = "--Please Select--";
  String selectedDivision = "--Please Select--";
  String selectedSubject = "--Please Select--";
  String selectedExamType = "--Please Select--";

  List<String> subjectList = [];
  List<Student> studentList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  void updateSubjectList(String Program, String ProgramTerm) {
    // Get the subject list based on the selected program and program term
    subjectList = SubjectLists.getSubjects(Program, ProgramTerm);
    setState(() {
      selectedSubject =
          subjectList.isNotEmpty ? subjectList[0] : "--Please Select--";
    });
  }

  Future<void> fetchStudentData() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot<Map<String, dynamic>> studentSnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(widget.program)
              .collection(selectedProgramTerm)
              .doc(selectedDivision)
              .collection('student')
              .orderBy('rollNumber')
              .get();

      studentList.clear(); // Clear existing list before fetching new data

      studentSnapshot.docs.forEach((doc) {
        studentList.add(Student(
          userId: doc.id,
          firstName: doc['First Name'],
          rollNo: doc['rollNumber'].toString(),
          lastName: doc['Last Name'],
          middleName: doc['Middle Name'],
        ));
      });

      await Future.forEach(studentList, (Student student) async {
        await fetchData(student);
      });

      setState(() {
        isLoading = false;
      }); // Update the UI after fetching data
    } catch (e) {
      print('Error fetching student data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData(Student student) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> resultSnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(widget.program)
              .collection(selectedProgramTerm)
              .doc(selectedDivision)
              .collection('student')
              .doc(student.userId)
              .collection('result')
              .doc('23-24')
              .get();

      Map<String, dynamic> resultData = resultSnapshot.data() ?? {};

      if (resultData.containsKey(selectedExamType)) {
        final practicalInternalData = resultData[selectedExamType];
        if (practicalInternalData.containsKey(selectedSubject)) {
          final projectData = practicalInternalData[selectedSubject];
          student.totalMarks = projectData['totalmarks'] ?? "Not Available";
          student.obtainMarks = projectData['obtainmarks'] ?? "Not Available";
        }
      }
    } catch (e) {
      print('Error fetching result data for student ${student.userId}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Internal Marks Details"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dropdowns for selecting program, term, division, subject, and exam
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text(
                      "Program Term",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.zero))),
                        value: selectedProgramTerm,
                        items: lists.programTerms
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedProgramTerm = val as String;
                            selectedSubject = "--Please Select--";
                            updateSubjectList(
                                widget.program, selectedProgramTerm);
                          });
                        }),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      "Division",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.zero))),
                        value: selectedDivision,
                        items: widget.program == "BCA"
                            ? lists.bcaDivision
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList()
                            : widget.program == "B-Com"
                                ? lists.bcomDivision
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList()
                                : lists.bbaDivision
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedDivision = val as String;
                          });
                        }),
                  ),
                ),
              ],
            ),
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
                    });
                  }),
            ),
            ListTile(
              title: const Text(
                "Subject",
                style: TextStyle(fontSize: 15),
              ),
              subtitle: DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero))),
                  value: selectedSubject,
                  items: subjectList
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedSubject = val as String;
                      fetchStudentData();
                    });
                  }),
            ),
            isLoading
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : studentList.isEmpty
                    ? Center(
                        child: Text(
                            'No Data Found'), // Show "No Data Found" if student list is empty
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columnSpacing: 10,
                          headingTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff002233)),
                          dataTextStyle: TextStyle(fontWeight: FontWeight.w500),
                          border: TableBorder.all(
                            style: BorderStyle.solid,
                          ),
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Roll\nNo')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('Obtain')),
                          ],
                          rows: studentList.map((student) {
                            final String name =
                                "${student.lastName} ${student.firstName} ${student.middleName}";
                            return DataRow(cells: <DataCell>[
                              DataCell(Text(
                                "${student.rollNo}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(name)),
                              DataCell(Text(student.totalMarks.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Center(
                                child: Text(student.obtainMarks.toString(),
                                    style: TextStyle(
                                        color: student.isPass()
                                            ? Colors.black
                                            : Colors.redAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
