import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

String dropdownValue = '';
String dpdownValue = '';

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

  // TimeOfDay selectedTime = TimeOfDay.now();
  //
  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: selectedTime,
  //   );
  //
  //   if (picked != null && picked != selectedTime) {
  //     setState(() {
  //       selectedTime = picked;
  //     });
  //   }
  // }

  final formkey = GlobalKey<FormState>();
  final toDateControler = TextEditingController();
  final fromDateControler = TextEditingController();
  Color formBorderColor = Colors.grey;

  int calculateDaysDifference(String fromdate, String todate) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime fromDate = format.parse(fromdate);
    DateTime toDate = format.parse(todate);
    Duration difference = toDate.difference(fromDate);
    return difference.inDays;
  }

  TextEditingController _timeController = TextEditingController();
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

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Assignment',
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          .9, // Set your desired width here
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
                        value: dpdownValue.isEmpty ? selectItem : dpdownValue,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            dpdownValue = newValue!;
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
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          .9, // Set your desired width here
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
                    // child: TextFormField(
                    //   decoration: InputDecoration(
                    //     labelText: 'Assignment Name',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                    child: ReusableTextField(
                      title: 'Assignment Name',
                      readOnly: false,
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
                    // child: TextFormField(
                    //   textAlign: TextAlign.start,
                    //   decoration: InputDecoration(
                    //     labelText: 'Instructions',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    //   maxLines: 3,
                    // ),
                    child: ReusableTextField(
                      title: 'Instructions',
                      readOnly:false,
                      isMulti: true,
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
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
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
                      validator: (value) =>
                          value!.isEmpty ? 'please give date' : null,
                      onChanged: (value) {
                        setState(
                          () {
                            if (value != null) {
                              formBorderColor = const Color(0xFFE91e63);
                            } else {
                              formBorderColor = Colors.grey;
                            }
                          },
                        );
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
                            labelText: 'Selected Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 20, left: 20),
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: 'Resubmission Of Rejected Assignment ',
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             suffixIcon: Switch(
            //               value: isSwitched,
            //               onChanged: (value) {
            //                 setState(() {
            //                   isSwitched = value;
            //                 });
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 20, left: 20),
            //         child: TextFormField(
            //           style: TextStyle(fontSize: 18),
            //           textAlign: TextAlign.center,
            //           decoration: InputDecoration(
            //             labelText:
            //                 'Extra Days For Resubmission Of Rejected Assignment',
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             // floatingLabelBehavior: FloatingLabelBehavior.always
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DottedBorder(
                  color: Colors.blue,
                  strokeWidth: 3,
                  dashPattern: [12, 11],
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 65,
                    color: Colors.white,
                    child:
                        //button ma asvhe a e nthi khabar mane ama inkwell thay ?
                        ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: ContinuousRectangleBorder()),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.plus_circle_fill,
                            color: Color(0xff225779),
                            size: 37,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Text('Create Assignment',
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
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
