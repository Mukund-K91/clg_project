import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:path/path.dart' as path;

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => EventListState();
}

bool isImage(String fileName) {
  final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
  final extension = fileName.split('.').last.toLowerCase();
  return imageExtensions.contains('.$extension');
}

class EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 25),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 150,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80))),
        centerTitle: true,
        title: Text(
          "Notice Board",
        ),
        backgroundColor: Color(0xff002233),
      ),
      body: eventList(),
    );
  }

  Widget eventList() {
    double? _progress;
    final CollectionReference eventsCollection =
    FirebaseFirestore.instance.collection('events');
    int rowIndex = 0; // Initialize the row index
    ScrollController _dataController1 = ScrollController();
    ScrollController _dataController2 = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: eventsCollection
      // Filter events by assignTo value
          .orderBy('date', descending: true)
          .where('assignTo', arrayContains: 'Dashboard')
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
              : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: events.docs.length,
            itemBuilder: (context, index) {
              final event = events.docs[index];
              final eventData = event.data() as Map<String, dynamic>;
              final Timestamp timestamp =
              eventData['date']; // Get the Timestamp
              final DateTime date = timestamp.toDate();
              final _date = DateFormat('dd-MMMM hh:mm a')
                  .format(date); // Convert to DateTime
              rowIndex++; // Increment row index for each row
              String fileUrl = eventData['File'];
              final String fileName = event['FileName'] ?? '';

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListTile(
                            enabled: false,
                            title: Text(
                              eventData['title'] ?? 'Title not available',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: ReadMoreText(
                              eventData['description'],
                              style: TextStyle(color: Colors.black),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              colorClickableText: Color(0xff4b8bfb),
                            ),
                            onTap: () {
                              // Add onTap logic here
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        // Add space between ListTile and trailing image
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // Adjust padding as needed
                          child: fileName.isNotEmpty &&
                              fileUrl.toString() != "null"
                              ? isImage(fileName)
                              ? Image(
                            width: 100,
                            height: 100,
                            image: NetworkImage(fileUrl),
                            fit: BoxFit.cover,
                          )
                              : IconButton(
                            iconSize: 30,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.fileArrowDown,
                              color: Colors.blueAccent,
                            ),
                          )
                              : null,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${_date}',
                        style:
                        TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

}
