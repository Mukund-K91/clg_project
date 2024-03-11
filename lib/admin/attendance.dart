import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../firebase_options.dart';
import '../reusable_widget/reusable_textfield.dart';
import '../storage_service.dart';

class Student {
  final String firstname;
  final String middlename;
  final String lastname;
  final String gender;
  final String userId;
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

  // Fetch students from Firestore based on program, program term, and division
  Stream<List<Student>> getStudents(
      String program, String programTerm, String division) {
    return _firestore
        .collection('students')
        .doc(program)
        .collection(programTerm)
        .doc(division)
        .collection('student')
        .orderBy('User Id')
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
        .where('Mobile', isGreaterThanOrEqualTo: searchTerm)
        .where('Mobile', isLessThanOrEqualTo: searchTerm + '\uf8ff')
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
                ))
            .toList());
  }
}

final _programs = ["--Please Select--", "BCA", "B-Com", "BBA"];
final _programTerm = [
  "--Please Select--",
  "Sem - 1",
  "Sem - 2",
  "Sem - 3",
  "Sem - 4",
  "Sem - 5",
  "Sem - 6"
];
final _Bcadivision = ["--Please Select--", "A", "B", "C", "D", "E", "F"];
final _Bcomdivision = ["--Please Select--", "A", "B", "C", "D", "E", "F", "G"];
final _Bbadivision = ["--Please Select--", "A", "B", "C", "D"];

final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _middleNameController = TextEditingController();
final TextEditingController _lastNameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _mobileNoController = TextEditingController();
late TextEditingController _UserIdController;
final TextEditingController _dobController = TextEditingController();
late TextEditingController _fileNameController = TextEditingController();
late TextEditingController _totalStudentsController = TextEditingController();
TextEditingController _rollNumberController = TextEditingController();
DateTime _activationDate = DateTime.now();
TextEditingController _activeDate = TextEditingController();
final FirestoreService _firestoreService = FirestoreService();
final TextEditingController _searchController = TextEditingController();
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
StorageService service = StorageService();

StorageService storageService = StorageService();
late CollectionReference _studentsCollection;
late DocumentReference _UserIdDoc;
int _lastUserId = 202400101;
int _totalStudent = 0;
late String imjUrl;

String? _selectedGender = 'Male';
DateTime? _selectedDate;

String? _selProgram = "--Please Select--";

String? _selProgramTerm = "--Please Select--";

String? _seldiv = "--Please Select--";
final _formKey = GlobalKey<FormState>();

/*===============================================*/
/*===============================================*/
/*===============================================*/

class StudentList extends StatefulWidget {
  final program;

  const StudentList({super.key, this.program});

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
  }

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool passwordObscured = true;

  Future<void> _getUserId() async {
    final userIdDocSnapshot = await _UserIdDoc.get();
    setState(() {
      _totalStudent =
          userIdDocSnapshot.exists && userIdDocSnapshot.data() != null
              ? (userIdDocSnapshot.data()
                      as Map<String, dynamic>)['Total Students'] ??
                  0
              : 0;
      _totalStudentsController.text = _totalStudent.toString();
    });
  }

  Future<void> _decreamentTotalStudents() async {
    _totalStudent--;
    await _UserIdDoc.update({'Total Students': _totalStudent});
  }

  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _searchController;
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
    _UserIdDoc =
        FirebaseFirestore.instance.collection('metadata').doc('userId');
    _getUserId();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
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
    final String _selectedProgram=widget.program;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
          const SizedBox(width: 8),

          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _selectedProgramTerm,
            onChanged: (String? value) {
              setState(() {
                _selectedProgramTerm = value!;
              });
            },
            items: _selectedProgram == ''
                ? []
                : _programTerm.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
            hint: const Text('Program Term'),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _selectedDivision,
            onChanged: (String? value) {
              setState(() {
                _selectedDivision = value!;
              });
            },
            items: _selectedProgramTerm == '--Please Select--'
                ? []
                : _selectedProgram == "BCA"
                    ? _Bcadivision.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        )).toList()
                    : _selectedProgram == "B-Com"
                        ? _Bcomdivision.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            )).toList()
                        : _Bbadivision.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            )).toList(),
            hint: const Text('Class'),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final String _selectedProgram=widget.program;
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
              child: Column(
                children: [
                  DataTable(
                    border: TableBorder.all(),
                    columns: const [
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
                      DataColumn(label: Text('Action')),
                    ],
                    rows: students
                        .map(
                          (student) => DataRow(cells: [
                            DataCell(Text(student.userId)),
                            DataCell(Text(
                                student.firstname + " " + student.lastname)),
                            DataCell(CircleAvatar(
                              radius: 27,
                              child: ClipOval(
                                child: Image.network(
                                  student.profile,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                            )),
                            DataCell(Text(student.program)),
                            DataCell(Text(student.programTerm)),
                            DataCell(Text(student.division)),
                            DataCell(Text(student.activationDate)),
                            DataCell(Text(student.DOB)),
                            DataCell(Text(student.mobile)),
                            DataCell(Text(student.email)),
                            DataCell(widget.program == "Super Admin"
                                ? Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            FontAwesomeIcons.edit,
                                            color: Colors.green,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            FontAwesomeIcons.trash,
                                            color: Colors.redAccent,
                                          )),
                                    ],
                                  )
                                : Text("Not Allowed!!"))
                          ]),
                        )
                        .toList(),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
