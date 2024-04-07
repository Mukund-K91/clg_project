import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../reusable_widget/reusable_textfield.dart';

class AttendanceDisplay extends StatefulWidget {
  final String program;
  final String programTerm;
  final String division;
  final String userId;

  const AttendanceDisplay({
    required this.program,
    required this.programTerm,
    required this.division,
    required this.userId,
  });

  @override
  State<AttendanceDisplay> createState() => _AttendanceDisplayState();
}

class _AttendanceDisplayState extends State<AttendanceDisplay> {
  final String _year = '2024';
  final String _ay = '2023-24';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATTENDANCE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              color: Color(0xff002233),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Program: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${widget.program}\n"),
                        const TextSpan(
                          text: "Program Term: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${widget.programTerm}\n"),
                        const TextSpan(
                          text: "Division: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${widget.division}\n"),
                        const TextSpan(
                          text: "AY: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${_ay}"),
                      ],
                    ),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .doc(widget.program)
                  .collection(widget.programTerm)
                  .doc(widget.division)
                  .collection('student')
                  .doc(widget.userId)
                  .collection('yearlyAttendance')
                  .doc(_year)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final data = snapshot.data?.data() ?? {};
                final subjectAttendance =
                    data['subjectAttendance'] as Map<String, dynamic>? ?? {};
                if (subjectAttendance.isEmpty) {
                  return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'No Data Found ! Please Check Selected Month or Contact Admin '),
                      ));
                }
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: subjectAttendance.entries.map((entry) {
                    final subject = entry.key;
                    final attendanceData =
                        entry.value as Map<String, dynamic>? ?? {};

                    final presentCount =
                        attendanceData['presentCount'] as int? ?? 0;
                    final absentCount =
                        attendanceData['absentCount'] as int? ?? 0;
                    final totalLectures = presentCount + absentCount;
                    final percentage = totalLectures != 0
                        ? ((presentCount / totalLectures) * 100)
                        .toStringAsFixed(1)
                        : '0.0';

                    return
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          child: ListTile(
                            subtitle: Text("Total Lecture: ${totalLectures}"),
                            title: Text("${subject}"),
                            trailing: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff002233),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 70,
                                width: 90,
                                child: Center(
                                    child: Text(
                                      "${percentage}%",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ),
                        ));
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

