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

/*===============================================*/
/*===============================================*/
/*===============================================*/

class Students extends StatefulWidget {
  final program;

  const Students(this.program, {Key? key}) : super(key: key);

  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List :${widget.program}'),
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
          DropdownButton<String>(
            value: _selectedProgramTerm,
            onChanged: (String? value) {
              setState(() {
                _selectedProgramTerm = value!;
              });
            },
            items: _selectedProgram == ""
                ? []
                : lists.programTerms.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
            hint: const Text('Program Term'),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedDivision,
            onChanged: (String? value) {
              setState(() {
                _selectedDivision = value!;
              });
            },
            items: _selectedProgramTerm == "--Please Select--"
                ? []
                : _selectedProgram == "BCA"
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
            hint: const Text('Class'),
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

        return RawScrollbar(
          padding: const EdgeInsets.all(20),
          thumbVisibility: true,
          trackVisibility: true,
          thumbColor: const Color(0xff002233),
          controller: _dataController2,
          child: SingleChildScrollView(
            controller: _dataController2,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _dataController1,
              child:
              DataTable(
                columnSpacing: 15,
                border: TableBorder.all(),
                columns: const [
                  DataColumn(label: Text('Roll No'), numeric: true),
                  DataColumn(label: Text('User Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Profile')),
                  DataColumn(label: Text('Program')),
                  DataColumn(label: Text('Program Term')),
                  DataColumn(label: Text('Division')),
                  DataColumn(label: Text('Activation Date')),
                  DataColumn(label: Text('DOB')),
                  DataColumn(label: Text('Mobile')),
                  DataColumn(label: Text('Email')),
                ],
                rows: students
                    .map(
                      (student) => DataRow(cells: [
                    DataCell(Text('${student.rollNo}')),
                    DataCell(Text(student.userId)),
                    DataCell(
                        Text(student.lastname + " " + student.firstname +" "+student.middlename)),
                    DataCell(
                      CircleAvatar(
                        radius: 27,
                        child: ClipOval(
                          child: Image.network(
                            student.profile,
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(student.program)),
                    DataCell(Text(student.programTerm)),
                    DataCell(Text(student.division)),
                    DataCell(Text(student.activationDate)),
                    DataCell(Text(student.DOB)),
                    DataCell(Text(student.mobile)),
                    DataCell(Text(student.email)),
                  ]),
                )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
