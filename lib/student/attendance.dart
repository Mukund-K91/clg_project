import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceDisplay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('students')
          .doc(program)
          .collection(programTerm)
          .doc(division)
          .collection('student')
          .doc(userId)
          .collection('monthlyAttendance')
          .doc('March_2024') // Replace with the actual month and year
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data?.data() ?? {};
        final subjectAttendance =
            data['subjectAttendance'] as Map<String, dynamic>? ?? {};

        return ListView(
          children: subjectAttendance.entries.map((entry) {
            final subject = entry.key;
            final attendanceData = entry.value as Map<String, dynamic>? ?? {};

            final presentCount = attendanceData['presentCount'] as int? ?? 0;
            final absentCount = attendanceData['absentCount'] as int? ?? 0;
            final totalLectures = presentCount + absentCount;
            final percentage =
                totalLectures != 0 ? (presentCount / totalLectures) * 100 : 0;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                height: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: Colors.grey,
                  elevation: 5,
                  color: Colors.green.shade200,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       Text(
                        '${subject}',
                        style: TextStyle(fontSize: 20),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Text(
                          "${percentage}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  )),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
