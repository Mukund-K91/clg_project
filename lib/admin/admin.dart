// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:clg_project/reusable_widget/reusable_textfield.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class StudentManage extends StatefulWidget {
//   const StudentManage({super.key});
//
//   @override
//   State<StudentManage> createState() => _MyWidgetState();
// }
//
// class _MyWidgetState extends State<StudentManage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   // text field controller
//   final TextEditingController _searchController = TextEditingController();
//   final TextEditingController _id = TextEditingController();
//   final TextEditingController _rollno = TextEditingController();
//   final TextEditingController _fname = TextEditingController();
//   final TextEditingController _lname = TextEditingController();
//   final TextEditingController _mobile = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final _divison = ["Div", "A", "B", "C", "D"];
//   String? _selectedDiv = "Div";
//   final CollectionReference _items =
//       FirebaseFirestore.instance.collection('students');
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String searchText = '';
//
//   // for create operation
//   Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(
//                   top: 20,
//                   right: 20,
//                   left: 20,
//                   bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "Add Student",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Padding(
//                           //   padding: const EdgeInsets.all(8.0),
//                           //   child: TextFormField(
//                           //     controller: _id,
//                           //     keyboardType: TextInputType.number,
//                           //     decoration: const InputDecoration(
//                           //       labelText: "SP ID",
//                           //       border: OutlineInputBorder(),
//                           //     ),
//                           //     validator: (value) {
//                           //       if (value!.isEmpty) {
//                           //         return "SP ID is required";
//                           //       }
//                           //       return null;
//                           //     },
//                           //   ),
//                           // ),
//                           ReusableTextField(
//                             controller: _id,
//                             keyboardType: TextInputType.number,
//                             enable: true,
//                             label: 'SP ID',
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "SP ID is required";
//                               }
//                               return null;
//                             }, title: 'SP ID',
//                           ),
//                           const SizedBox(
//                             height: 4,
//                           ),
//                           ReusableTextField(
//                             controller: _rollno,
//                             label: 'Roll No',
//                             keyboardType: TextInputType.phone,
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "Roll No is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 4),
//                           ReusableTextField(
//                             controller: _fname,
//                             label: 'First Name',
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "First Name is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(
//                             height: 4,
//                           ),
//                           ReusableTextField(
//                             controller: _lname,
//                             label: 'Last Name',
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "Last Name is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(
//                             height: 4,
//                           ),
//                           ReusableTextField(
//                             controller: _email,
//                             keyboardType: TextInputType.emailAddress,
//                             label: 'Email Id',
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "Email is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(
//                             height: 4,
//                           ),
//                           ReusableTextField(
//                             controller: _mobile,
//                             label: 'Mobile No',
//                             keyboardType: TextInputType.phone,
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty || str.length > 10) {
//                                 return "10 Digit no. is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: DropdownButtonFormField(
//                                 decoration: const InputDecoration(
//                                     border: OutlineInputBorder()),
//                                 value: _selectedDiv,
//                                 items: _divison
//                                     .map((e) => DropdownMenuItem(
//                                           value: e,
//                                           child: Text(e),
//                                         ))
//                                     .toList(),
//                                 onChanged: (val) {
//                                   setState(() {
//                                     _selectedDiv = val as String;
//                                   });
//                                 }),
//                           ),
//                           SizedBox(
//                             width: 150,
//                             child: Reusablebutton(
//                               onPressed: () async {
//                                 final String email = _email.text;
//                                 final String password = _mobile.text;
//                                 if (_formKey.currentState!.validate()) {
//                                   final credential = await FirebaseAuth
//                                       .instance
//                                       .createUserWithEmailAndPassword(
//                                       email: email, password: password);
//                                   await _items.add({
//                                     "SP ID": _id.text,
//                                     "Roll No":_rollno.text,
//                                     "First Name": _fname.text,
//                                     "Last Name": _lname.text,
//                                     "Mobile": _mobile.text,
//                                     "Email": _email.text,
//                                     "Password": _mobile.text,
//                                     "Div": _selectedDiv
//                                   });
//                                   _id.text = '';
//                                   _rollno.text='';
//                                   _fname.text = '';
//                                   _lname.text = '';
//                                   _email.text = '';
//                                   _mobile.text = '';
//                                   _selectedDiv = "Div";
//                                   Navigator.of(context).pop();
//                                 }
//                               },
//                               Style: false,
//                               child: const Text(
//                                 " Register ",
//                                 style: TextStyle(color: Colors.white, fontSize: 20),
//                               ),),
//                           ),
//                           // SizedBox(
//                           //   height: 60,
//                           //   width: 150,
//                           //   child: ElevatedButton(
//                           //       style: ElevatedButton.styleFrom(
//                           //         shape: RoundedRectangleBorder(
//                           //             borderRadius: BorderRadius.circular(5)),
//                           //         backgroundColor: const Color(0xff002233),
//                           //       ),
//                           //       onPressed: () async {
//                           //         final String email = _email.text;
//                           //         final String password = _mobile.text;
//                           //         if (_formKey.currentState!.validate()) {
//                           //           final credential = await FirebaseAuth
//                           //               .instance
//                           //               .createUserWithEmailAndPassword(
//                           //                   email: email, password: password);
//                           //           await _items.add({
//                           //             "SP ID": _id.text,
//                           //             "Roll No":_rollno.text,
//                           //             "First Name": _fname.text,
//                           //             "Last Name": _lname.text,
//                           //             "Mobile": _mobile.text,
//                           //             "Email": _email.text,
//                           //             "Password": _mobile.text,
//                           //             "Div": _selectedDiv
//                           //           });
//                           //           _id.text = '';
//                           //           _rollno.text='';
//                           //           _fname.text = '';
//                           //           _lname.text = '';
//                           //           _email.text = '';
//                           //           _mobile.text = '';
//                           //           _selectedDiv = "Div";
//                           //           Navigator.of(context).pop();
//                           //         }
//                           //       },
//                           //       child: const Text(
//                           //         "Register",
//                           //         style: TextStyle(
//                           //             color: Colors.white, fontSize: 20),
//                           //       )),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   // for Update operation
//   Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
//     if (documentSnapshot != null) {
//       _id.text = documentSnapshot['SP ID'].toString();
//       _rollno.text = documentSnapshot['Roll No'].toString();
//       _fname.text = documentSnapshot['First Name'].toString();
//       _lname.text = documentSnapshot['Last Name'].toString();
//       _email.text = documentSnapshot['Email'].toString();
//       _mobile.text = documentSnapshot['Mobile'].toString();
//       _selectedDiv = documentSnapshot['Div'].toString();
//     }
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(
//                   top: 20,
//                   right: 20,
//                   left: 20,
//                   bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "Update Student Info",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Form(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ReusableTextField(
//                             controller: _id,
//                             label: 'SP ID',
//                             keyboardType: TextInputType.phone,
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "SP ID is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 4),
//                           ReusableTextField(
//                             controller: _rollno,
//                             label: 'Roll No',
//                             keyboardType: TextInputType.phone,
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "Roll No is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 4),
//                           ReusableTextField(
//                             controller: _fname,
//                             label: 'First Name',
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "First Name is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 4),
//                           ReusableTextField(
//                             controller: _lname,
//                             label: 'Last Name',
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "Last Name is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 4),
//                           ReusableTextField(
//                             controller: _email,
//                             label: 'Email Id',
//                             enable: true,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (str) {
//                               if (str!.isEmpty) {
//                                 return "Email is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 4),
//                           ReusableTextField(
//                             controller: _mobile,
//                             label: 'Mobile No',
//                             enable: true,
//                             validator: (str) {
//                               if (str!.isEmpty || str.length > 10) {
//                                 return "10. Digit no. is required";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: DropdownButtonFormField(
//                                 decoration: const InputDecoration(
//                                     border: OutlineInputBorder()),
//                                 value: _selectedDiv,
//                                 items: _divison
//                                     .map((e) => DropdownMenuItem(
//                                           value: e,
//                                           child: Text(e),
//                                         ))
//                                     .toList(),
//                                 onChanged: (val) {
//                                   setState(() {
//                                     _selectedDiv = val as String;
//                                   });
//                                 }),
//                           ),
//                           SizedBox(
//                             width: 150,
//                             child: Reusablebutton(onPressed: () async {
//                               await _items
//                                   .doc(documentSnapshot!.id)
//                                   .update({
//                                 "SP ID": _id.text,
//                                 "First Name": _fname.text,
//                                 "Last Name": _lname.text,
//                                 "Mobile": _mobile.text,
//                                 "Email": _email.text,
//                                 "Password": _mobile.text,
//                                 "Div": _selectedDiv
//                               });
//                               _id.text = '';
//                               _fname.text = '';
//                               _lname.text = '';
//                               _email.text = '';
//                               _mobile.text = '';
//                               _selectedDiv = "Div";
//
//                               Navigator.of(context).pop();
//                             }, Style: false,
//                             child: const Text(
//                               "Update",
//                               style: TextStyle(
//                                   color: Colors.white, fontSize: 20),
//                             )),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   // for delete operation
//   Future<void> _delete(String productID) async {
//    await AwesomeDialog(
//       context: context,
//       dialogType: DialogType.question,
//       btnOkOnPress: () async {
//         await _items.doc(productID).delete();
//         // for snackBar
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text("You have successfully deregister Student")));
//       },
//      showCloseIcon: true,
//       title: "Are You Sure?",
//     ).show();
//     // await _items.doc(productID).delete();
//
//
//   }
//
//   void _onSearchChanged(String value) {
//     setState(() {
//       searchText = value;
//     });
//   }
//
//   bool isSearchClicked = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xff002233),
//         title: isSearchClicked
//             ? Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: _onSearchChanged,
//                   decoration: const InputDecoration(
//                       contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
//                       hintStyle: TextStyle(color: Colors.black),
//                       border: InputBorder.none,
//                       hintText: 'Search..'),
//                 ),
//               )
//             : const Text(
//                 'Students',
//                 style: TextStyle(color: Colors.white),
//               ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   isSearchClicked = !isSearchClicked;
//                 });
//               },
//               icon: Icon(
//                 isSearchClicked ? Icons.close : Icons.search,
//                 color: Colors.white,
//               ))
//         ],
//       ),
//       body: StreamBuilder(
//         stream: _items.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             final List<DocumentSnapshot> items = streamSnapshot.data!.docs
//                 .where((doc) => doc['First Name'].toLowerCase().contains(
//                       searchText.toLowerCase(),
//                     ))
//                 .toList();
//             return ListView.builder(
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   final DocumentSnapshot documentSnapshot = items[index];
//                   return Card(
//                     color: const Color(0xff002233),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     margin: const EdgeInsets.all(10),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 17,
//                         backgroundColor: const Color(0xffffffff),
//                         child: Text(
//                           documentSnapshot['Division'].toString(),
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.black),
//                         ),
//                       ),
//                       title: InkWell(
//                         child: Text(
//                           documentSnapshot['First Name'] +
//                               " " +
//                               documentSnapshot['Last Name'],
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                       ),
//                       subtitle: Text(
//                         documentSnapshot['User Id'].toString(),
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                       trailing: SizedBox(
//                         width: 100,
//                         child: Row(
//                           children: [
//                             IconButton(
//                                 color: Colors.white,
//                                 onPressed: () => _update(documentSnapshot),
//                                 icon: const Icon(Icons.edit)),
//                             IconButton(
//                                 color: Colors.white,
//                                 onPressed: () => _delete(documentSnapshot.id),
//                                 icon: const Icon(Icons.delete)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 });
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       // Create new project button
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _create(),
//         backgroundColor: const Color(0xff002233),
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
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
