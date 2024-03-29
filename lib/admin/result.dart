import 'dart:async';
import 'package:clg_project/reusable_widget/lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Student {
  final String firstname;
  final String middlename;
  final String lastname;
  final String gender;
  final String userId;
  final int rollNo;
  final String activationDate;
  final String profile;
  final String email;
  final String mobile;
  final String DOB;
  final String program;
  final String programTerm;
  final String division;
  final String password;

  Student(
      {required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.gender,
      required this.userId,
      required this.rollNo,
      required this.activationDate,
      required this.profile,
      required this.email,
      required this.mobile,
      required this.DOB,
      required this.program,
      required this.programTerm,
      required this.division,
      required this.password});

  // Convert Student object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "First Name": firstname,
      "Middle Name": middlename,
      "Last Name": lastname,
      "Gender": gender,
      "User Id": userId,
      "Activation Date": activationDate,
      "Profile Img": profile,
      "Email": email,
      "Mobile": mobile,
      "DOB": DOB,
      'program': program,
      'programTerm': programTerm,
      'division': division,
      'Password': password,
    };
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add student to Firestore
  Future<void> addStudent(Student student) async {
    try {
      await _firestore
          .collection('students')
          .doc(student.program)
          .collection(student.programTerm)
          .doc(student.division)
          .collection('student')
          .doc(student.userId)
          .set(student.toMap());
      print("Done");
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  // Fetch students from Firestore based on program, program term, and division
  Stream<List<Student>> getStudents(
      String program, String programTerm, String division) {
    return _firestore
        .collection('students')
        .doc(program)
        .collection(programTerm)
        .doc(division)
        .collection('student')
        .orderBy('Last Name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Student(
                  firstname: doc['First Name'],
                  middlename: doc['Middle Name'],
                  lastname: doc['Last Name'],
                  gender: doc['Gender'],
                  userId: doc['User Id'],
                  activationDate: doc['Activation Date'],
                  profile: doc['Profile Img'],
                  email: doc['Email'],
                  mobile: doc['Mobile'],
                  DOB: doc['DOB'],
                  program: doc['program'],
                  programTerm: doc['programTerm'],
                  division: doc['division'],
                  password: doc['Password'],
                  rollNo: doc['rollNumber'],
                ))
            .toList());
  }

  Stream<List<Student>> searchStudents(
      String program, String programTerm, String division, String searchTerm) {
    return _firestore
        .collection('students')
        .doc(program)
        .collection(programTerm)
        .doc(division)
        .collection('student')
        .where('First Name', isGreaterThanOrEqualTo: searchTerm)
        .where('First Name', isLessThanOrEqualTo: searchTerm + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Student(
                  firstname: doc['First Name'],
                  middlename: doc['Middle Name'],
                  lastname: doc['Last Name'],
                  gender: doc['Gender'],
                  userId: doc['User Id'],
                  activationDate: doc['Activation Date'],
                  profile: doc['Profile Img'],
                  email: doc['Email'],
                  mobile: doc['Mobile'],
                  DOB: doc['DOB'],
                  program: doc['program'],
                  programTerm: doc['programTerm'],
                  division: doc['division'],
                  password: doc['Password'],
                  rollNo: doc['rollNumber'],
                ))
            .toList());
  }
}

final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
late DocumentReference _UserIdDoc;
late String imjUrl;
TextEditingController _obtainMarks=TextEditingController();
TextEditingController _totalMarks=TextEditingController();
List<String> subjectList = [];
String selectedSubject = "--Please Select--"; // Default subject

class ResultPage extends StatefulWidget {
  final program;

  const ResultPage(this.program, {Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool passwordObscured = true;

  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _searchController;
  String? _selectedProgram;
  String? _selectedProgramTerm = "--Please Select--";
  String? _selectedDivision = "--Please Select--";
  late String _searchTerm;
  ScrollController _dataController1 = ScrollController();
  ScrollController _dataController2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchTerm = '';
    _searchController = TextEditingController();
    _selectedProgram =
        widget.program; // Initialize _selectedProgram with widget.program
  }
  void updateSubjectList(String Program, String ProgramTerm) {
    // Get the subject list based on the selected program and program term
    subjectList = SubjectLists.getSubjects(Program, ProgramTerm);
    setState(() {
      //selectedSubject = subjectList.isNotEmpty ? subjectList[0] : null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internal Exam: ${widget.program}'),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _buildStudentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              hintText: 'Search by name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchTerm = value;
              });
            },
          ),
          const SizedBox(height: 8),
         Row(children: [
           Expanded(child: ListTile(
             title: const Text(
               "Program Term",
               style: TextStyle(fontSize: 15),
             ),
             subtitle: DropdownButtonFormField(
               isExpanded: true,
                 decoration: const InputDecoration(
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.zero))),
                 value: _selectedProgramTerm,
                 items: lists.programTerms
                     .map((e) => DropdownMenuItem(
                   value: e,
                   child: Text(e),
                 ))
                     .toList(),
                 onChanged: (val) {
                   setState(() {
                     _selectedProgramTerm = val as String;
                     selectedSubject = "--Please Select--";
                     updateSubjectList(
                         _selectedProgram.toString(), _selectedProgramTerm.toString());
                   });
                 }),
           ),),
           Expanded(child: ListTile(
             title: const Text(
               "Division",
               style: TextStyle(fontSize: 15),
             ),
             subtitle: DropdownButtonFormField(
                 isExpanded: true,
                 decoration: const InputDecoration(
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.zero))),
                 value: _selectedDivision,
                 items: _selectedProgram == "BCA"
                     ? lists.bcaDivision
                     .map((e) => DropdownMenuItem(
                   value: e,
                   child: Text(e),
                 ))
                     .toList()
                     : _selectedProgram == "B-Com"
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
                     _selectedDivision = val as String;
                   });
                 }),
           ),)
         ],),
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
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return StreamBuilder<List<Student>>(
      stream: _searchTerm.isEmpty
          ? _firestoreService.getStudents(
              _selectedProgram!, _selectedProgramTerm!, _selectedDivision!)
          : _firestoreService.searchStudents(_selectedProgram!,
              _selectedProgramTerm!, _selectedDivision!, _searchTerm),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final students = snapshot.data;

        if (students == null || students.isEmpty) {
          return const Center(
            child: Text('No students found'),
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 10,
              border: TableBorder.symmetric(outside: BorderSide.none),
              columns: const [
                DataColumn(label: Text('Roll No'), numeric: true),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Obtain')),
              ],
              rows: students
                  .map(
                    (student) => DataRow(cells: [
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text('${student.rollNo}',style: TextStyle(fontSize: 20),),
                      )),
                      DataCell(
                          Text(student.lastname + " " + student.firstname)),
                      DataCell(Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          width: 50,
                          child:TextFormField(
                            onChanged: (value) {
                              // Update the total marks controller when the user changes the total marks
                              _totalMarks.text = value;
                            },
                            controller: _totalMarks,
                            maxLength: 3,
                            enableSuggestions: true,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      )),
                      DataCell(Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          width: 50,
                          child: TextFormField(
                            maxLength: 3,
                            enableSuggestions: true,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value != null) {
                                int? totalMarks = int.tryParse(_totalMarks.text);
                                int? obtainMarks = int.tryParse(value);
                                if (totalMarks == null || obtainMarks == null) {
                                  return 'Enter valid marks';
                                }
                                if (obtainMarks > totalMarks) {
                                  return 'Obtain marks should not be greater than total marks';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      )),

                    ]),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
