import 'package:clg_project/noticeboard.dart';
import 'package:clg_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../admin/Material.dart';
import '../admin/PageNotAvailable.dart';
import 'admin.dart';
import 'attendance.dart';


class FacultyDashboard extends StatelessWidget {
  String UserId;
  String _user;

  FacultyDashboard(this.UserId, this._user, {super.key});

  Future<Map<String, dynamic>?> _UserData(String enteredUserId) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collectionGroup('faculty').get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> document
    in querySnapshot.docs) {
      final userData = document.data();
      final String documentUserId = document.id;

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
        future: _UserData(UserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('User not found or invalid credentials');
          } else {
            final userData = snapshot.data!;
            final String Name =
                userData['First Name'] + " " + userData['Last Name'];
            final String ProfileUrl =userData['Profile Img'];
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
                                 CircleAvatar(
                                  radius: 40,
                                  child: ClipOval(
                                    child: Image.network(
                                      ProfileUrl,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userData['First Name'] +
                                          " " +
                                          userData['Last Name'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      userData['program'],
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Attendance(),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(FontAwesomeIcons.calendarDay,
                                      color: Color(0xff002233)),
                                ),
                                const Text(
                                  "Attendance",
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
                                  onPressed: () {},
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
                                  onPressed: () {
                                    String name =
                                        userData['First Name'] + userData['Last Name'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NoticeBoard(name, _user),
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
