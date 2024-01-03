import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // List<Map<String, dynamic>> studentList = [];
  // String selectedDivision = 'Div';
  // final _divison = ["Div", "A", "B", "C", "D"];
  // List<int> clickCounts = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _initializeClickCounts();
  //   fetchData();
  // }
  //
  // void _changeColorAndText(int index) {
  //   setState(() {
  //     studentList[index]['clickCounts'] = (
  //       studentList[index],
  //       clickCounts[index] = (clickCounts[index] + 1) % 3
  //     );
  //   });
  // }
  // void _resetButtonColor() {
  //   setState(() {
  //     studentList.forEach((student) {
  //       student['clickCount'] = 0;
  //     });
  //   });
  // }
  // Color _getButtonColor(int index) {
  //   switch (clickCounts[index]) {
  //     case 1:
  //       return Colors.green;
  //     case 2:
  //       return Colors.red;
  //     default:
  //       return Colors.white;
  //   }
  // }
  //
  // String _getButtonText(int index) {
  //   switch (clickCounts[index]) {
  //     case 1:
  //       return 'Present';
  //     case 2:
  //       return 'Absent';
  //     default:
  //       return 'Take';
  //   }
  // }
  //
  // void _initializeClickCounts() {
  //   // Fetch the total number of students and set initial clickCounts
  //   FirebaseFirestore.instance
  //       .collection('students')
  //       .get()
  //       .then((querySnapshot) {
  //     setState(() {
  //       clickCounts = List.generate(querySnapshot.size, (index) => 0);
  //     });
  //   });
  // }
  //
  // Future<void> fetchData() async {
  //   // Fetch data from Firestore
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await FirebaseFirestore.instance.collection('students').get();
  //
  //   // Convert QuerySnapshot to List
  //   List<Map<String, dynamic>> allStudents = querySnapshot.docs
  //       .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  //     return doc.data();
  //   }).toList();
  //
  //   // Filter and sort the data based on the selected division and roll number
  //   setState(() {
  //     studentList = allStudents
  //         .where((student) => student['Div'] == selectedDivision)
  //         .toList();
  //     studentList.sort((a, b) => a['Roll No'].compareTo(b['Roll No']));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayStudents("A"),
                                ));
                          },
                          iconSize: 50,
                          icon: const Icon(
                            FontAwesomeIcons.a,
                            color: Color(0xff002233),
                          ),
                        ),
                        const Text(
                          "TYBCA-A",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayStudents("B"),
                                ));
                          },
                          iconSize: 50,
                          icon: const Icon(FontAwesomeIcons.b,
                              color: Color(0xff002233)),
                        ),
                        const Text(
                          "TYBCA-B",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayStudents("C"),
                                ));
                          },
                          iconSize: 50,
                          icon: const Icon(FontAwesomeIcons.c,
                              color: Color(0xff002233)),
                        ),
                        const Text(
                          "TYBCA-C",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayStudents("D"),
                                ));
                          },
                          iconSize: 50,
                          icon: const Icon(FontAwesomeIcons.d,
                              color: Color(0xff002233)),
                        ),
                        const Text(
                          "TYBCA-D",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        );
  }
}

class DisplayStudents extends StatefulWidget {
  String _div;

  DisplayStudents(this._div, {super.key});

  @override
  State<DisplayStudents> createState() => _DisplayStudentsState();
}

class _DisplayStudentsState extends State<DisplayStudents> {
  List<Map<String, dynamic>> studentList = [];
  List<int> clickCounts = [];

  @override
  void initState() {
    super.initState();
    _initializeClickCounts();
    fetchData();
  }

  void _changeColorAndText(int index) {
    setState(() {
      studentList[index]['clickCounts'] = (
        studentList[index],
        clickCounts[index] = (clickCounts[index] + 1) % 3
      );
    });
  }
  void _resetButtonColor() {
    setState(() {
      studentList.forEach((student) {
        student['clickCount'] = 0;
      });
    });
  }

  Color _getButtonColor(int index) {
    switch (clickCounts[index]) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  String _getButtonText(int index) {
    switch (clickCounts[index]) {
      case 1:
        return 'Present';
      case 2:
        return 'Absent';
      default:
        return 'Take';
    }
  }

  void _initializeClickCounts() {
    // Fetch the total number of students and set initial clickCounts
    FirebaseFirestore.instance
        .collection('students')
        .get()
        .then((querySnapshot) {
      setState(() {
        clickCounts = List.generate(querySnapshot.size, (index) => 0);
      });
    });
  }

  Future<void> fetchData() async {
    // Fetch data from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('students').get();

    // Convert QuerySnapshot to List
    List<Map<String, dynamic>> allStudents = querySnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      return doc.data();
    }).toList();

    // Filter and sort the data based on the selected division and roll number
    setState(() {
      studentList = allStudents
          .where((student) => student['Div'] == widget._div)
          .toList();
      studentList.sort((a, b) => a['Roll No'].compareTo(b['Roll No']));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: studentList.isEmpty
            ? Center(
                child: Text("No"),
              )
            : Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: studentList.length,
                          itemBuilder: (context, index) {
                            var student = studentList[index];
                            return Card(
                              color: const Color(0xff002233),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: const Color(0xffffffff),
                                  child: Text(
                                    student['Div'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                title: InkWell(
                                  child: Text(
                                    student['Roll No'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                subtitle: Text(
                                  student['First Name'] +
                                      " " +
                                      student['Last Name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      maximumSize: Size(100, 40),
                                      minimumSize: Size(100, 40),
                                      primary: _getButtonColor(index)),
                                  onPressed: () {
                                    _changeColorAndText(index);
                                  },
                                  child: Text(
                                    _getButtonText(index),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          })),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: const Color(0xff002233),
                        ),
                        onPressed: () {
                          studentList.forEach((student) {
                            student['clickCount'] = 0;
                          });
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
