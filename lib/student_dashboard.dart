import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentDashboard extends StatelessWidget {
  String email;

  StudentDashboard(this.email, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchDataByEmail(email),
        // Replace with the desired email
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error} USER NOT FOUND'),
                ElevatedButton(
                    onPressed: () {}, child: Text('Return Home Page')),
                
              ],
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('No data found for the given email.');
          } else {
            // Data found, you can access it using snapshot.data
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Stack(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
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
                          height: 200,
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  foregroundImage:
                                      AssetImage("assets/images/ex_img.png"),
                                ),
                                Text(
                                  "${data['First Name']}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text("${data['SP ID']}")
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
                                  onPressed: () {},
                                  iconSize: 50,
                                  icon: Icon(
                                    FontAwesomeIcons.calendarDay,
                                    color: Color(0xff002233),
                                  ),
                                ),
                                Text(
                                  "Attendence",
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
                                  onPressed: () {},
                                  iconSize: 50,
                                  icon: Icon(FontAwesomeIcons.book,
                                      color: Color(0xff002233)),
                                ),
                                Text(
                                  "Syllabus",
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
                                  onPressed: () {},
                                  iconSize: 50,
                                  icon: Icon(FontAwesomeIcons.filePen,
                                      color: Color(0xff002233)),
                                ),
                                Text(
                                  "Assignment",
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
                                  onPressed: () {},
                                  iconSize: 50,
                                  icon: Icon(FontAwesomeIcons.fileContract,
                                      color: Color(0xff002233)),
                                ),
                                Text(
                                  "Results",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.newspaper,
                        color: Color(0xff002233),
                      ),
                      title: Text("Latest News & Events"),
                      trailing: Icon(
                        FontAwesomeIcons.anglesRight,
                        color: Color(0xff002233),
                      ),
                    )
                  ],
                )
              ],
            );
          }
        },
      ),
      // Stack(
      //   children: [
      //     Container(
      //       height: 100,
      //       decoration: BoxDecoration(
      //           color: Color(0xff002233),
      //           borderRadius: BorderRadius.only(
      //               bottomLeft: Radius.circular(40),
      //               bottomRight: Radius.circular(40))),
      //     ),
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Align(
      //           alignment: Alignment.topCenter,
      //           child: Padding(
      //             padding: const EdgeInsets.all(15),
      //             child: Container(
      //               width: double.infinity,
      //               height: 200,
      //               child: Card(
      //                 color: Colors.white,
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                   children: [
      //                     CircleAvatar(
      //                       radius: 50,
      //                       foregroundImage:
      //                       AssetImage("assets/images/ex_img.png"),
      //                     ),
      //                     Text(
      //                       "MUKUND K",
      //                       style: TextStyle(fontSize: 20),
      //                     ),
      //                     Text("TYBCA-C")
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         Expanded(
      //           child: GridView.count(
      //             primary: false,
      //             padding: const EdgeInsets.all(20),
      //             crossAxisSpacing: 10,
      //             mainAxisSpacing: 10,
      //             crossAxisCount: 2,
      //             children: <Widget>[
      //               Card(
      //                 color: Colors.white,
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     IconButton(
      //                       onPressed: () {},
      //                       iconSize: 50,
      //                       icon: Icon(
      //                         FontAwesomeIcons.calendarDay,
      //                         color: Color(0xff002233),
      //                       ),
      //                     ),
      //                     Text(
      //                       "Attendence",
      //                       style: TextStyle(fontSize: 20),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               Card(
      //                 color: Colors.white,
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     IconButton(
      //                       onPressed: () {},
      //                       iconSize: 50,
      //                       icon: Icon(FontAwesomeIcons.book,
      //                           color: Color(0xff002233)),
      //                     ),
      //                     Text(
      //                       "Syllabus",
      //                       style: TextStyle(fontSize: 20),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               Card(
      //                 color: Colors.white,
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     IconButton(
      //                       onPressed: () {},
      //                       iconSize: 50,
      //                       icon: Icon(FontAwesomeIcons.filePen,
      //                           color: Color(0xff002233)),
      //                     ),
      //                     Text(
      //                       "Assignment",
      //                       style: TextStyle(fontSize: 20),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               Card(
      //                 color: Colors.white,
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     IconButton(
      //                       onPressed: () {},
      //                       iconSize: 50,
      //                       icon: Icon(FontAwesomeIcons.fileContract,
      //                           color: Color(0xff002233)),
      //                     ),
      //                     Text(
      //                       "Results",
      //                       style: TextStyle(fontSize: 20),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(
      //             FontAwesomeIcons.newspaper,
      //             color: Color(0xff002233),
      //           ),
      //           title: Text("Latest News & Events"),
      //           trailing: Icon(
      //             FontAwesomeIcons.anglesRight,
      //             color: Color(0xff002233),
      //           ),
      //         )
      //       ],
      //     )
      //   ],
      // ),
    );
  }
}

Future<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchDataByEmail(
    String email) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    Future<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot =
        firestore
            .collection('students')
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
