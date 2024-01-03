import 'package:clg_project/noticeboard.dart';
import 'package:clg_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../admin/Material.dart';
import '../admin/PageNotAvailable.dart';
import 'attendance.dart';


class StudentDashboard extends StatelessWidget {
  String email;
  String _user;
  StudentDashboard(this.email, this._user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder<DocumentSnapshot>(
        future: fetchDataByEmail(email),
        // Replace with the desired email
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                          height: 200,
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 50,
                                  foregroundImage:
                                      AssetImage("assets/images/ex_img.png"),
                                ),
                                Text(
                                  "${data['First Name']}",
                                  style: const TextStyle(fontSize: 20),
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
                                  onPressed: () {
                                  },
                                  iconSize: 50,
                                  icon: const Icon(
                                    FontAwesomeIcons.calendarDay,
                                    color: Color(0xff002233),
                                  ),
                                ),
                                const Text(
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FilesUpload(_user),
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
                                  onPressed: () async {
                                    await pagenotfound(context,'No assignment to submit woo hoo :)');
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.filePen,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
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
                                  onPressed:() async {
                                    await pagenotfound(context,'Results not published yet...!');
                                  },
                                  iconSize: 50,
                                  icon: const Icon(
                                      FontAwesomeIcons.fileContract,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
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
                      leading: const Icon(
                        FontAwesomeIcons.newspaper,
                        color: Color(0xff002233),
                      ),
                      title: const Text("Latest Notice & Events"),
                      trailing: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.anglesRight,
                          color: Color(0xff002233),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoticeBoard(email,_user),
                              ));
                        },
                      ),
                    )
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
