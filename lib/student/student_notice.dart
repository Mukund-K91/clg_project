import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentNotice extends StatefulWidget {
  StudentNotice({super.key});

  @override
  State<StudentNotice> createState() => _StudentNoticeState();
}

class _StudentNoticeState extends State<StudentNotice> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final CollectionReference _con =
      FirebaseFirestore.instance.collection('Notice');

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  bool isSearchClicked = false;
  @override
  String searchText = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff002233),
        title: isSearchClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      hintText: 'Search..'),
                ),
              )
            : const Text(
                'Notice & Events',
                style: TextStyle(color: Colors.white),
              ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchClicked = !isSearchClicked;
                });
              },
              icon: Icon(
                isSearchClicked ? Icons.close : Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: _con.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<DocumentSnapshot> items = streamSnapshot.data!.docs
                .where((doc) => doc['Title'].toLowerCase().contains(
                      searchText.toLowerCase(),
                    ))
                .toList();
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = items[index];
                  return Card(
                    color: const Color(0xff002233),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            documentSnapshot['Title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            documentSnapshot['Date'] +
                                " " +
                                documentSnapshot['Time'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            "- " + documentSnapshot['Name'],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              splashColor: Colors.white,
                              child: Text(
                                "Read >>",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(),
                                  backgroundColor: Colors.white,
                                  constraints: BoxConstraints(
                                    minWidth: double.infinity,
                                    minHeight: MediaQuery.of(context).size.height/1.5,
                                    maxHeight: MediaQuery.of(context).size.height/1.5,
                                  ),
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext ctx) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                documentSnapshot['Description'],
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Create new project button
    );
  }
}
