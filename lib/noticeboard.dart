import 'dart:async';
import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeBoard extends StatefulWidget {
  String name;
  String user;

  NoticeBoard(this.name, this.user, {super.key});

  @override
  State<NoticeBoard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NoticeBoard> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final CollectionReference _con =
  FirebaseFirestore.instance.collection('Notice');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _timeString;

  void initState() {
    _timeString = _Time(DateTime.now());
    _timeString = _Date(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTimeString());
    super.initState();
  }

  _getTimeString() {
    final DateTime now = DateTime.now();
    final String formattedTime = _Time(now);
    final String formattedDate = _Date(now);

    setState(() {
      _timeString = formattedTime;
    });
  }

  @override
  String searchText = '';

  String _Time(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }

  String _Date(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  // for create operation
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery
                      .of(ctx)
                      .viewInsets
                      .bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Notice",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReusableTextField(
                            controller: _title,
                            label: 'Title',
                            enable: true,
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _description,
                            label: 'Description',
                            isMulti: true,
                            enable: true,
                            keyboardType: TextInputType.multiline,
                          ),
                          const SizedBox(height: 8,),
                          ReusablebuttonHome(onPressed: () async {
                            await _con.add({
                              "Title": _title.text,
                              "Description": _description.text,
                              "Date": _Date(DateTime.now()),
                              "Time": _Time(DateTime.now()),
                              "Name": widget.name
                            });
                            _title.text = "";
                            _description.text = "";
                            Navigator.of(context).pop();
                          }, child: const Text(
                            "Publish",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // for Update operation
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _title.text = documentSnapshot['Title'].toString();
      _description.text = documentSnapshot['Description'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery
                      .of(ctx)
                      .viewInsets
                      .bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Update Notice",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReusableTextField(
                            controller: _title,
                            enable: false,
                            label: 'Title',),
                          const SizedBox(height: 4,),
                          ReusableTextField(
                            controller: _description,
                            label: 'Description',
                            keyboardType: TextInputType.multiline,
                            enable: true,
                            isMulti: true
                          ),
                          const SizedBox(height: 8,),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: const Color(0xff002233),
                              ),
                              onPressed: () async {
                                await _con.doc(documentSnapshot!.id).update({
                                  "Description": _description.text,
                                  "Date": _Date(DateTime.now()),
                                  "Time": _Time(DateTime.now()),
                                  "Name": widget.name
                                });
                                _title.text = "";
                                _description.text = "";
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // for delete operation
  Future<void> _delete(String productID) async {
    await _con.doc(productID).delete();

    // for snackBar
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Deleted")));
  }

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
            "Notice & Events",
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
                  .where((doc) =>
                  doc['Title'].toLowerCase().contains(
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
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: widget.user == 'Faculty'
                                ? SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    color: Colors.white,
                                    onPressed: () =>
                                        _update(documentSnapshot),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    onPressed: () =>
                                        _delete(documentSnapshot.id),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            )
                                : Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              "- " + documentSnapshot['Name'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                splashColor: Colors.white,
                                child: const Text(
                                  "Read More >>",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(),
                                      backgroundColor: const Color(0xff002233),
                                      constraints: BoxConstraints(
                                        minWidth: double.infinity,
                                        minHeight:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height /
                                            1.5,
                                        maxHeight:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height /
                                            1.5,
                                      ),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext ctx) {
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(10),
                                                child: Text(
                                                  documentSnapshot[
                                                  'Description'],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
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
        floatingActionButton: widget.user == 'Faculty'
            ? FloatingActionButton(
            onPressed: () => _create(),
            backgroundColor: const Color(0xff002233),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ))
            : null);
  }
}
