import 'package:clg_project/noticeboard.dart';
import 'package:clg_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../admin/Material.dart';
import '../admin/PageNotAvailable.dart';
import '../event_screen.dart';
import '../reusable_widget/img_slider.dart';
import '../reusable_widget/notice_board_list.dart';
import '../student/attendance.dart';
import '../student/profile.dart';
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
                    child: Expanded(
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
                                      builder: (context) =>
                                          Profile(userData['User Id'],'Student'),
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
                                subtitle: Text("${userData['program']}",
                                    style:
                                    const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Students(userData['program']),));
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
                                        builder: (context) => EventList(),
                                      ));
                                },
                                child: Text("view all >>")),
                          ),
                          buildEventList()
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
