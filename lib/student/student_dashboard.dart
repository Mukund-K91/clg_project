import 'package:clg_project/event_screen.dart';
import 'package:clg_project/noticeboard.dart';
import 'package:clg_project/reusable_widget/img_slider.dart';
import 'package:clg_project/reusable_widget/notice_board_list.dart';
import 'package:clg_project/student/Studentassignment.dart';
import 'package:clg_project/student/attendance.dart';
import 'package:clg_project/student/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../admin/Material.dart';
import '../admin/PageNotAvailable.dart';

class StudentDashboard extends StatelessWidget {
  String UserId;
  String _user;

  StudentDashboard(this.UserId, this._user, {super.key});

  Future<Map<String, dynamic>?> _UserData(String enteredUserId) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('student').get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
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

  void initSate() {
    ImgSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _UserData(UserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('User not found or invalid credentials');
          } else {
            final userData = snapshot.data!;
            final String Name =
                userData['First Name'] + " " + userData['Last Name'];
            final String program = userData['program'] +
                " | " +
                userData['programTerm'] +
                " | " +
                userData['division'];
            final String ProfileUrl = userData['Profile Img'];
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 7,
                  decoration: const BoxDecoration(
                      color: Color(0xff002233),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(
                                        userData['User Id'], 'Student'),
                                  ));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 27,
                                child: ClipOval(
                                  child: Image.network(
                                    ProfileUrl,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                              ),
                              title: Text(
                                "${Name}",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              subtitle: Text("${program}",
                                  style:
                                      const TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ImgSlider(),
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        // Number of columns in the grid
                        shrinkWrap: true,
                        // Ensure that the grid view occupies only the necessary space
                        physics: NeverScrollableScrollPhysics(),
                        // Disable scrolling
                        children: [
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
                                              AttendanceDisplay(
                                            userId: userData['User Id'],
                                            program: userData['program'],
                                            programTerm:
                                                userData['programTerm'],
                                            division: userData['division'],
                                          ),
                                        ));
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
                                      ),
                                    );
                                  },
                                  iconSize: 50,
                                  icon: const Icon(
                                    FontAwesomeIcons.book,
                                    color: Color(0xff002233),
                                  ),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Studentassignment(),
                                        ));
                                  },
                                  iconSize: 50,
                                  icon: const Icon(
                                    FontAwesomeIcons.filePen,
                                    color: Color(0xff002233),
                                  ),
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
                                  onPressed: () async {
                                    await pagenotfound(context,
                                        'Results not published yet...!');
                                  },
                                  iconSize: 50,
                                  icon: const Icon(
                                    FontAwesomeIcons.fileContract,
                                    color: Color(0xff002233),
                                  ),
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
                      ListTile(
                        title: Text(
                          "Latest News",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoticeBoard(
                                        userData['First Name'], _user),
                                  ));
                            },
                            child: Text("view all >>")),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ))
              ],
            );
          }
        },
      ),
    );
  }
}
