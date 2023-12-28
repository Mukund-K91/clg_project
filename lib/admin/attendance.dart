import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('students');
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  bool isSearchClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff002233),
        title: const Text(
                'Students',
                style: TextStyle(color: Colors.white),
              ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _items.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<DocumentSnapshot> items = streamSnapshot.data!.docs
                .where((doc) => doc['First Name'].toString().contains(
                      searchText.toUpperCase(),
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
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 17,
                        backgroundColor: const Color(0xffffffff),
                        child: Text(
                          documentSnapshot['Div'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      title: InkWell(
                        child: Text(
                          documentSnapshot['Roll No'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      subtitle: Text(
                        documentSnapshot['First Name'] +
                            " " +
                            documentSnapshot['Last Name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
