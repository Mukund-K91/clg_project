import 'package:clg_project/event_screen.dart';
import 'package:clg_project/reusable_widget/img_slider.dart';
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
                                  style: const TextStyle(color: Colors.white)),
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
                        child: ImgSlider(context),
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
                                    await pagenotfound(context,
                                        'No assignment to submit woo hoo :)');
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
                                    builder: (context) => EventList(),
                                  ));
                            },
                            child: Text("view all>>")),
                      ),
                      _buildEventList()
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

  Widget _buildEventList() {
    final CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');
    int rowIndex = 0; // Initialize the row index
    ScrollController _dataController1 = ScrollController();
    ScrollController _dataController2 = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: eventsCollection
          // Filter events by assignTo value
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data;
        if (events == null) {
          return const Center(
            child: Text('No Events found'),
          );
        }
        double listViewHeight = events.docs.length * 80.0;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: events.docs.isEmpty
              ? Center(
                  child: Text("No Announcement Published"),
                )
              : SizedBox(
                  height: listViewHeight,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events.docs.length,
                    itemBuilder: (context, index) {
                      final event = events.docs[index];
                      final eventData = event.data() as Map<String, dynamic>;
                      final Timestamp timestamp =
                          eventData['date']; // Get the Timestamp
                      final DateTime date = timestamp.toDate();
                      final _date = DateFormat('dd-MM-yyyy hh:mm a')
                          .format(date); // Convert to DateTime

                      rowIndex++; // Increment row index for each row
                      String fileUrl = eventData['File'];

                      return Card(
                        child: ListTile(
                          title: Text(
                            eventData['title'] ?? 'Title not available',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '${_date}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                          ),
                          onTap: () {
                            // Add onTap logic here if needed
                          },
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
