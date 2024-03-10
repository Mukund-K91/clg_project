import 'package:carousel_slider/carousel_slider.dart';
import 'package:clg_project/noticeboard.dart';
import 'package:clg_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../admin/Material.dart';
import '../admin/PageNotAvailable.dart';
import 'attendance.dart';


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
  final List<String> imageUrls = [
    'https://via.placeholder.com/600x300?text=Image1',
    'https://via.placeholder.com/600x300?text=Image2',
    'https://via.placeholder.com/600x300?text=Image3',
    'https://via.placeholder.com/600x300?text=Image4',
  ];
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder<Map<String, dynamic>?>(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _Slider(context)
                          // CarouselSlider(
                          //   options: CarouselOptions(
                          //     autoPlay: true,
                          //   ),
                          //   items: imageUrls.map((url) {
                          //     return Builder(
                          //       builder: (BuildContext context) {
                          //         return Container(
                          //           margin: EdgeInsets.symmetric(horizontal: 5.0),
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(8.0),
                          //             image: DecorationImage(
                          //               image: NetworkImage(url),
                          //               fit: BoxFit.cover,
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     );
                          //   }).toList(),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(10),
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
                                    await pagenotfound(context,
                                        'No assignment to submit woo hoo :)');
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
                                  onPressed: () async {
                                    await pagenotfound(context,
                                        'Results not published yet...!');
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
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
  Widget _Slider(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('slider_data').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<String> imageUrls = snapshot.data!.docs.map((doc) {
          return doc['imageUrl'] as String;
        }).toList();

        return CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            autoPlay: true,
          ),
          items: imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(

                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
