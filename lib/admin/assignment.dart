import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

String dropdownValue = '';

const carType = <String>[
  '1',
  '2',
  '3',
  '4',
  '5',
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AssignmentPage(),
    );
  }
}

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({Key? key}) : super(key: key);

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

var selectItem = carType.first;

class _AssignmentPageState extends State<AssignmentPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: Color(0xff225779),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/arrow.png'),
                  Text(
                    'Create Assignment',
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Expanded(
                    child: Container(
                      width: 371, // Set your desired width here
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                        borderRadius:
                            BorderRadius.circular(8.0), // Border radius
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButton<String>(
                        value:
                            dropdownValue.isEmpty ? selectItem : dropdownValue,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: carType.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Expanded(
                    child: Container(
                      width: 371, // Set your desired width here
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                        borderRadius:
                            BorderRadius.circular(8.0), // Border radius
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButton<String>(
                        value:
                            dropdownValue.isEmpty ? selectItem : dropdownValue,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: carType.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Assignment Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        labelText: 'Instructions',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, left: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Due Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Resubmission Of Rejected Assignment ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText:
                            'Extra Days For Resubmission Of Rejected Assignment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // floatingLabelBehavior: FloatingLabelBehavior.always
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xffffffff))),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.plus_circle_fill,
                        color: Color(0xff225779),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text('Create Assignment'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
