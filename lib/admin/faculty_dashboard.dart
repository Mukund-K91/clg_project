import 'dart:async';
import 'package:clg_project/admin/noticeboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'Material.dart';
import 'PageNotAvailable.dart';
import 'admin.dart';

class FacultyDashboard extends StatefulWidget {
  String email;
  String _user;

  FacultyDashboard(this.email, this._user, {super.key});

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchDataByEmail(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Error: ${snapshot.error} USER NOT FOUND\nplease contact your administrator eCollegeAdmin@gmail.com'),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeMain(),
                          ));
                    },
                    child: const Text('Return Home Page')),
              ],
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('No data found for the given email.');
          } else {
            // Data found, you can access it using snapshot.data
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Stack(
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      color: Color(0xff002233),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: Card(
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  foregroundImage:
                                      AssetImage("assets/images/ex_img.png"),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data['First Name'] +
                                          " " +
                                          data['Last Name'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      data['Department'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                                          builder: (context) => StudentManage(),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(
                                    FontAwesomeIcons.userGraduate,
                                    color: Color(0xff002233),
                                  ),
                                ),
                                const Text(
                                  "Students",
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
                                    await pagenotfound(context,
                                        'This Feature Not available Yet...!\nunder progress');
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.calendarDay,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Attendence",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          // Card(
                          //   color: Colors.white,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       IconButton(
                          //         onPressed: () async {
                          //           await pagenotfound(context,'This Feature Not available Yet...!\nunder progress');
                          //         },
                          //         iconSize: 50,
                          //         icon: const Icon(FontAwesomeIcons.filePen,
                          //             color: Color(0xff002233)),
                          //       ),
                          //       const Text(
                          //         "Assignment",
                          //         style: TextStyle(fontSize: 20),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Card(
                          //   color: Colors.white,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       IconButton(
                          //         onPressed: () {},
                          //         iconSize: 50,
                          //         icon: const Icon(
                          //             FontAwesomeIcons.fileContract,
                          //             color: Color(0xff002233)),
                          //       ),
                          //       const Text(
                          //         "Results",
                          //         style: TextStyle(fontSize: 20),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                                          builder: (context) =>
                                              FilesUpload(widget._user),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.book,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Material",
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
                                    String name =
                                        data['First Name'] + data['Last Name'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NoticeBoard(name,widget._user),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.newspaper,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Notice & Events",
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
              ],
            );
          }
        },
      ),
    );
  }
}

Future<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchDataByEmail(
    String email) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    Future<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot =
        firestore
            .collection('faculty')
            .where('Email', isEqualTo: email)
            .get()
            .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot
            .docs[0]; // Assuming there's only one matching document
      } else {
        throw Exception('No document found with the given email.');
      }
    });

    return documentSnapshot;
  } catch (e) {
    print('Error fetching data: $e');
    return null;
  }
}
