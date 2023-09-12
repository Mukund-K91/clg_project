import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

enum GenderTypeEnum { Donwloadable, Deliverable }

class add_student extends StatelessWidget {
  add_student({super.key});

  DatabaseReference query = FirebaseDatabase.instance.ref().child('Students');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "STUDENTS",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff002233),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => student_add_form(),
                    ));
              },
              icon: const Icon(
                FontAwesomeIcons.add,
                size: 35,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Students').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                  leading: Text(
                    document["SP ID"],
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff002233),
                        fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    document["First Name"],
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("TYBCA-C"),
                  trailing: IconButton(
                      iconSize: 20,
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.pen)));
            }).toList(),
          );
        },
      ),
    );
  }
}

class student_add_form extends StatefulWidget {
  student_add_form({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<student_add_form> createState() => _student_add_formState();
}

class _student_add_formState extends State<student_add_form> {
  final TextEditingController _date = TextEditingController();

  TextEditingController _id = TextEditingController();
  final TextEditingController _fname = TextEditingController();

  final TextEditingController _lname = TextEditingController();

  TextEditingController _mobile = TextEditingController();
  TextEditingController _email = TextEditingController();

  _student_add_formState() {
    _selectedcat = _Category[0];
  }

  @override
  String _selectedGender = 'Male';
  final _Category = ["none", "SC", "OBC", "General", "ST", "Other"];
  String? _selectedcat = "SC";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD Student",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff002233),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _id,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "SP ID",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("SP ID is required"),
                      ));
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _fname,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("SP ID is required"),
                      ));
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _lname,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("SP ID is required"),
                      ));
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: _date,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.calendar),
                        labelText: "DOB",
                        border: OutlineInputBorder()),
                    onTap: () async {
                      DateTime? pickdate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickdate != null) {
                        setState(() {
                          _date.text =
                              DateFormat("dd-MM-yyyy").format(pickdate);
                        });
                      }
                      validator:
                      (value) {
                        if (value!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("SP ID is required"),
                          ));
                        }
                        return null;
                      };
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _mobile,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Mobile No",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("SP ID is required"),
                      ));
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email-Id",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("SP ID is required"),
                      ));
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    value: _selectedcat,
                    items: _Category.map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        )).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedcat = val as String;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 60,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: const Color(0xff002233),
                        ),
                        onPressed: () {
                          CollectionReference collRef =
                              FirebaseFirestore.instance.collection('Students');
                          collRef.add({
                            "SP ID": _id.text,
                            "First Name": _fname.text,
                            "Last Name": _lname.text,
                            "DOB": _date.text,
                            "Mobile": _mobile.text,
                            "Email-Id": _email.text,
                            "Category": _selectedcat.toString(),
                            "Password": _mobile.text
                          });
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.bottomSlide,
                              showCloseIcon: true,
                              title: "Student added successfully",
                              desc: "Student Id : ${_id.text}",
                              btnOkOnPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => add_student(),
                                    ));
                              }).show();
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                  SizedBox(
                    height: 60,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "RESET",
                          style:
                              TextStyle(color: Color(0xff002233), fontSize: 20),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
