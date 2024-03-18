import 'package:clg_project/reusable_widget/lists.dart';
import 'package:clg_project/reusable_widget/reusable_appbar.dart';
import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? _selProgram = "--Please Select--";

String? _selProgramTerm = "--Please Select--";

String? _seldiv = "--Please Select--";

class AssignmentPage extends StatefulWidget {
  String program;

  AssignmentPage(this.program, {Key? key}) : super(key: key);

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  bool isSwitched = false;

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

  final TextEditingController _timeController = TextEditingController();
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

  void initState() {
    super.initState();
    _selProgram = "--Please Select--";
    _selProgramTerm = "--Please Select--";
    _seldiv = "--Please Select--";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: CustomAppBar(title: 'Create Assignment'),
      body: SingleChildScrollView(
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
                          borderRadius: BorderRadius.all(Radius.zero))),
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
                    });
                  }),
            ),
            ListTile(
              title: const Text(
                "Division",
                style: TextStyle(fontSize: 15),
              ),
              subtitle: DropdownButtonFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero))),
                  value: _seldiv,
                  items: _selProgram == "BCA"
                      ? lists.bcaDivision
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList()
                      : _selProgram == "B-Com"
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
                  onChanged: (val) {
                    setState(() {
                      _seldiv = val as String;
                    });
                  }),
            ),
            const SizedBox(
              height: 25,
            ),
            const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: ReusableTextField(
                      title: 'Assignment Name',
                      readOnly: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: ReusableTextField(
                      title: 'Instructions',
                      readOnly: false,
                      isMulti: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
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
                            labelText: 'Due Time',
                            prefixIcon: const Icon(Icons.access_time),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const ContinuousRectangleBorder()),
                      onPressed: () {},
                      child: const Row(
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
                          Text('Reference Material',
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform
                            .pickFiles(allowMultiple: true, type: FileType.any);
                      },
                      child: const Text('Create Assignment'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
