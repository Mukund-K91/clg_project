import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  @override
  String _selectedGender = 'Male';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ADD Students",
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
                      border: OutlineInputBorder()
                  ),
                  onTap: () async {
                    DateTime? pickdate = await showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(200),
                        lastDate:DateTime.now(),);

                    if(pickdate!=null){
                      setState(() {
                        _date.text=DateF
                      });
                    }
                  },
                ),
              ),
              Text("Contact Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Last Name",
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
            ],
          ),
        ),
      ),

      // SingleChildScrollView(
      //     child: Padding(
      //   padding: const EdgeInsets.all(10),
      //   child: Form(
      //       child: Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child:
      //         TextFormField(
      //           decoration: InputDecoration(
      //             labelText: "SP ID",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child:
      //         TextFormField(
      //           decoration: InputDecoration(
      //             labelText: "First Name",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(
      //           decoration: InputDecoration(
      //             labelText: "Last Name",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //       ),
      //       Container(
      //         width: 200,
      //         padding: EdgeInsets.all(8.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             RadioListTile(value: null, groupValue: null, onChanged: null)
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(
      //           decoration: InputDecoration(
      //             labelText: "Full Name",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //       ),
      //     ],
      //   )),
      // )),
    );
  }
}
