import 'package:clg_project/noticeboard.dart';
import 'package:clg_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../admin/Material.dart';
import '../admin/PageNotAvailable.dart';
import 'attendance.dart';
class Student {
  final String name;
  final String mobile;

  Student({
    required this.name,
    required this.mobile,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['First Name'] ?? '',
      mobile: map['Mobile'] ?? '',
    );
  }
}


class StudentDashboard extends StatelessWidget {
  String UserId;
  String _user;
  StudentDashboard(this.UserId, this._user, {super.key});

  Future<Map<String, dynamic>?> _login(String enteredUserId) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collectionGroup('student').get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
      final userData = document.data();
      final String documentUserId = document.id;
      final String mobile = userData?['Mobile'];

      // Check if the document userId (user ID) matches the entered userId and mobile number matches the entered mobile number
      if (documentUserId == enteredUserId) {
        return userData;
      }
    }

    return null; // Return null if user data is not found
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder<Map<String, dynamic>?>(
        future: _login(UserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('User not found or invalid credentials');
          } else {
            final userData = snapshot.data!;
            final String Name = userData['First Name']+" "+userData['Last Name'];
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
                        child: Expanded(
                          child: Container(
                            width: double.infinity,
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
                                    "${Name}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(userData['program']),
                                ],
                              ),
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
                                builder: (context) => NoticeBoard(UserId,_user),
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

// Future<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchDataByEmail(
//     String userId) {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   try {
//     Future<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot =
//         firestore
//             .collectionGroup('student')
//             .where('User Id', isEqualTo: userId)
//             .get()
//             .then((querySnapshot) {
//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot
//             .docs[0]; // Assuming there's only one matching document
//       } else {
//         throw Exception('No document found with the given email.');
//       }
//     });
//     return documentSnapshot;
//   } catch (e) {
//     print('Error fetching data: $e');
//     return null;
//   }
// }


