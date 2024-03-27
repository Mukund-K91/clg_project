import 'dart:io';
import 'package:clg_project/reusable_widget/lists.dart';
import 'package:clg_project/reusable_widget/reusable_appbar.dart';
import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:clg_project/student/Studentassignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AssignmentPage extends StatefulWidget {
  String userType;
  String Name;
  String program;

  AssignmentPage(this.userType,this.Name, this.program, {Key? key}) : super(key: key);

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: FloatingActionButton(
          backgroundColor: Color(0xff002233),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AssignmentCreate(widget.userType,widget.Name, widget.program),
                ));
          },
          child: Text(
            'Create Assignment',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        appBar: CustomAppBar(title: 'Assignments'),
        body: AssignmentStream());
  }
}

class AssignmentCreate extends StatefulWidget {
  String userType;
  String Name;
  String program;

  AssignmentCreate(this.userType,this.Name, this.program, {Key? key}) : super(key: key);

  @override
  State<AssignmentCreate> createState() => _AssignmentCreateState();
}

class _AssignmentCreateState extends State<AssignmentCreate> {
  String? _selProgram = "--Please Select--";
  String? _selProgramTerm = "--Please Select--";
  String selectedSubject = "--Please Select--"; // Default subject
  List<String> subjectList = [];
  final date = DateTime.now();
  final toDateControler = TextEditingController();
  final fromDateControler = TextEditingController();
  final _instructions = TextEditingController();
  final _timeController = TextEditingController();

  Color formBorderColor = Colors.grey;
  late FilePickerResult? selectedFile;

  void initState() {
    super.initState();
    _selProgram = widget.program;
    _selProgramTerm = "--Please Select--";
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = result;
      });
    }
  }

  Future<String?> _uploadFileToStorage() async {
    if (selectedFile != null) {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('reference_material');
      String fileName = selectedFile!.files.single.name;
      File file = File(selectedFile!.files.single.path!);

      // Upload the file to Firebase Storage
      try {
        await storageReference.child(fileName).putFile(file);
        String fileUrl =
            await storageReference.child(fileName).getDownloadURL();
        return fileUrl;
      } on FirebaseException catch (e) {
        print('Error uploading file: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  void _createAssignment() async {
    // Get the assignment details
    String instructions =
        _instructions.text; // Replace with the actual instructions
    String assignedDate =
        DateFormat('dd-MM-yyyy hh:mm a').format(date).toString();
    String dueDate = fromDateControler.text; // Get the due date
    String dueTime = _timeController.text; // Get the due time

    // Show a circular progress indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Upload reference material to Firebase Storage and get the download URL
    String? referenceMaterialUrl = await _uploadFileToStorage();

    // Store assignment details in Firestore
    if (referenceMaterialUrl != null) {
      await FirebaseFirestore.instance.collection('assignments').add({
        'facultyName': widget.Name,
        'program': widget.program,
        'programTerm': _selProgramTerm,
        'subject': selectedSubject,
        'instructions': instructions,
        'dueDate': dueDate,
        'dueTime': dueTime,
        'assignedDate': assignedDate,
        'referenceMaterialUrl': referenceMaterialUrl,
        // Add more fields as needed
      });

      // Reset values upon successful creation
      _instructions.clear();
      fromDateControler.clear();
      _timeController.clear();
      selectedFile = null;
      selectedSubject = "--Please Select--";
      _selProgram = widget.program;
      _selProgramTerm = "--Please Select--";

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentPage(widget.userType,widget.Name, widget.program),
          ));

      // Show a snackbar to indicate successful creation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assignment created successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Hide the progress indicator
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create assignment. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = selectedTime.format(context);
      });
    }
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
        appBar: CustomAppBar(title: 'Create Assignment'),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Program Term",
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    value: _selProgramTerm,
                    items: lists.programTerms
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selProgramTerm = val as String;
                        selectedSubject = "--Please Select--";
                        updateSubjectList(_selProgram!, _selProgramTerm!);
                      });
                    },
                  ),
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
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
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
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: ReusableTextField(
                    keyboardType: TextInputType.multiline,
                    controller: _instructions,
                    title: 'Instructions',
                    readOnly: false,
                    maxLines: 5,
                    isMulti: true,
                  ),
                ),
                SizedBox(height: 15),
                Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 20),
                      child: TextFormField(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            fromDateControler.text =
                                '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                          }
                        },
                        readOnly: true,
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: fromDateControler,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          hintText: 'Due Date',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          counterText: "",
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: formBorderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              formBorderColor = const Color(0xFFE91e63);
                            } else {
                              formBorderColor = Colors.grey;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _timeController,
                            readOnly: true,
                            onTap: () => _selectTime(context),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: 'Due Time',
                              prefixIcon: const Icon(Icons.access_time),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DottedBorder(
                    color: Colors.blue,
                    strokeWidth: 3,
                    dashPattern: [12, 11],
                    child: Container(
                      width: double.infinity,
                      height: 65,
                      color: Colors.white,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const ContinuousRectangleBorder(),
                        ),
                        onPressed: _selectFile,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.plus_circle_fill,
                              color: Color(0xff225779),
                              size: 37,
                            ),
                            SizedBox(width: 18),
                            Text(
                              'Reference Material',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Reusablebutton(
                    onPressed: () {
                      setState(() {
                        _instructions.text;
                        _createAssignment();
                      });
                    },
                    Style: false,
                    child: Text(
                      'Create Assignment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ));
    ;
  }
}

class AssignmentStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('assignments').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return AssignmentCard(
              assignment: Assignment.fromMap(data),
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Deletion"),
                      content: Text(
                          "Are you sure you want to delete this assignment?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            deleteAssignmentAndFile(
                                document.id, data['referenceMaterialUrl']);
                          },
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}


Future<void> deleteAssignmentAndFile(
    String assignmentId, String fileUrl) async {
  try {
    // Delete assignment document from Firestore
    await FirebaseFirestore.instance
        .collection('assignments')
        .doc(assignmentId)
        .delete();

    // Extract file name from the URL
    String fileName = fileUrl.split('/').last;

    // Delete file from Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('reference_material/$fileName');
    await storageReference.delete();
  } catch (e) {
    print('Error deleting assignment and file: $e');
    // Handle error
  }
}

class Assignment {
  final String id;
  final String facultyName;
  final String program;
  final String programTerm;
  final String division;
  final String subject;
  final String instructions;
  final String dueDate;
  final String dueTime;
  final String assignedDate;

  final String referenceMaterialUrl;

  Assignment({
    required this.id,
    required this.facultyName,
    required this.program,
    required this.programTerm,
    required this.division,
    required this.subject,
    required this.instructions,
    required this.dueDate,
    required this.dueTime,
    required this.assignedDate,
    required this.referenceMaterialUrl,
  });

  factory Assignment.fromMap(Map<String, dynamic> data) {
    return Assignment(
      id: data['id'] ?? '',
      facultyName: data['facultyName'] ?? '',
      program: data['program'] ?? '',
      programTerm: data['programTerm'] ?? '',
      division: data['division'] ?? '',
      subject: data['subject'] ?? '',
      instructions: data['instructions'] ?? '',
      dueDate: data['dueDate'] ?? '',
      dueTime: data['dueTime'] ?? '',
      referenceMaterialUrl: data['referenceMaterialUrl'] ?? '',
      assignedDate: data['assignedDate'],
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onDelete;

  AssignmentCard({
    required this.assignment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${assignment.subject}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${assignment.assignedDate}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete,color: Color(0xff002233),),
          onPressed: onDelete,
        ),
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
              backgroundColor: Colors.white,
              context: context,
              builder: (BuildContext ctx) {
                return Scaffold(
                 appBar:  AppBar(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${assignment.facultyName}'),
                    ),
                    leadingWidth: double.infinity,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SampleCard(
                            color: Colors.grey.shade200,
                            cardName: 'Subject',
                            cardDes: '${assignment.subject}'),
                        SampleCard(
                            color: Colors.grey.shade200,
                            cardName: 'Assigned Date',
                            cardDes: '${assignment.assignedDate}'),
                        SampleCard(
                            color: Colors.grey.shade200,
                            cardName: 'Due Date & Time',
                            cardDes: '${assignment.dueDate} ${assignment.dueTime}'),
                        SampleCard(
                            color: Colors.grey.shade200,
                            cardName: 'Instruction',
                            cardDes: '${assignment.instructions}')
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
