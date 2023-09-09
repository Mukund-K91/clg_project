import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


enum GenderTypeEnum { Donwloadable, Deliverable }

class add_student extends StatelessWidget {
  const add_student({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "STUDENTS",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff002233),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => student_add_form(),
                    ));
              },
              icon: Icon(
                FontAwesomeIcons.add,
                size: 35,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    foregroundImage: AssetImage("man.png"),
                  ),
                  title: Text("Mukund"),
                  subtitle: Text("TYBCA-C"),
                  trailing: IconButton(
                      onPressed: () {}, icon: Icon(FontAwesomeIcons.pen))),
            ],
          )
        ],
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
  TextEditingController _date = TextEditingController();
  // TextEditingController _id = TextEditingController();
  // TextEditingController _fname = TextEditingController();
  // TextEditingController _lname = TextEditingController();
  // TextEditingController _mobile = TextEditingController();
  // TextEditingController _email = TextEditingController();

  _student_add_formState() {
    _selectedcat = _Category[0];
  }

  @override
  String _selectedGender = 'Male';
  final _Category = ["SC", "OBC", "General", "ST", "Other"];
  String? _selectedcat = "SC";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ADD Student",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff002233),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "SP ID",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Female'),
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
                      title: Text('Male'),
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
                    decoration: InputDecoration(
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
                    controller: _date,
                    decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.calendar),
                        labelText: "Admission Date",
                        border: OutlineInputBorder()),
                    onTap: () async {
                      DateTime? pickdate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
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
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Mobile No",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email-Id",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
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
                          backgroundColor: Color(0xff002233),
                        ),
                        onPressed: () {},
                        child: Text(
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
                        child: Text(
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
