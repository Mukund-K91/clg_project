import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

enum GenderTypeEnum { Donwloadable, Deliverable }

class add_student extends StatelessWidget {
  add_student({super.key});

  // DatabaseReference query = FirebaseDatabase.instance.ref().child('Students');

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
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      document["Div"],
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff002233),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    document["First Name"] + document["Last Name"],
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(document["SP ID"]),
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

  @override
  State<student_add_form> createState() => _student_add_formState();
}

class _student_add_formState extends State<student_add_form> {
  final TextEditingController _date = TextEditingController();

  TextEditingController _id = TextEditingController();
  final TextEditingController _fname = TextEditingController();

  final TextEditingController _lname = TextEditingController();

  TextEditingController _mobile = TextEditingController();

  _student_add_formState() {
    _selectedDiv = _divison[0];
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      CollectionReference collRef =
          FirebaseFirestore.instance.collection('students');
      collRef.add({
        "SP ID": _id.text,
        "First Name": _fname.text,
        "Last Name": _lname.text,
        "DOB": _date.text,
        "Mobile": _mobile.text,
        "Password": _mobile.text,
        "Div": _selectedDiv
      });
      AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          showCloseIcon: true,
          title: "Student added successfully",
          desc: "SP ID : ${_id.text.toString()}\nName :${_fname.text.toString()}${_lname.text.toString()}",
          btnOkOnPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => add_student(),
                ));
          }).show();
    }
  }

  @override
  String _selectedGender = 'Male';
  final _divison = ["Div", "A", "B", "C", "D"];
  String? _selectedDiv = "Div";

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
          child: Form(
            key: _formKey,
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
                        return "SP ID is required";
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
                        return "First Name is required";
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
                        return "Last Name is required";
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
                      if (value!.isEmpty || value.length > 10) {
                        return "10 Digit no. is required";
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
                      value: _selectedDiv,
                      items: _divison
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDiv = val as String;
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
                          onPressed: _submit,
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
                            style: TextStyle(
                                color: Color(0xff002233), fontSize: 20),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
