import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_project/reusable_widget/reusable_appbar.dart';
import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class NoticeBoard extends StatefulWidget {
  String name;
  String user;

  NoticeBoard(this.name, this.user, {super.key});

  @override
  State<NoticeBoard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NoticeBoard> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final CollectionReference _con =
      FirebaseFirestore.instance.collection('Notice');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

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
  // for create operation
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    // Clear text controllers
    _title.clear();
    _description.clear();

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
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
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
                      key: _formKey1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReusableTextField(
                            controller: _title,
                            title: 'Title',
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _description,
                            title: 'Description',
                            isMulti: true,
                            keyboardType: TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: 150,
                            child: Reusablebutton(
                              onPressed: () async {
                                if (_formKey1.currentState!.validate()) {
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
                                }
                              },
                              Style: false,
                              child: const Text(
                                " Publish ",
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
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
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
                            title: 'Title',
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          ReusableTextField(
                              controller: _description,
                              title: 'Description',
                              keyboardType: TextInputType.multiline,
                              isMulti: true),
                          const SizedBox(
                            height: 8,
                          ),
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
                                  "Title": _title.text,
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
        appBar: CustomAppBar(title: 'Notice'),
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
                      color: Color(0xff002233),
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
                                    documentSnapshot['Title'] ??
                                        'Title not available',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: ReadMoreText(
                                    documentSnapshot['Description'],
                                    style: TextStyle(color: Colors.white),
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    colorClickableText: Color(0xff4b8bfb),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Add space between ListTile and trailing image
                              Column(
                                children: [
                                  widget.user == 'Faculty'
                                      ? IconButton(
                                          color: Colors.white,
                                          onPressed: () =>
                                              _update(documentSnapshot),
                                          icon: const Icon(Icons.edit),
                                        )
                                      : Text(
                                          "- " + documentSnapshot['Name'],
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                  widget.user == 'Faculty'
                                      ? IconButton(
                                          color: Colors.white,
                                          onPressed: () => AwesomeDialog(
                                                  dismissOnTouchOutside: false,
                                                  context: context,
                                                  dialogType:
                                                      DialogType.question,
                                                  animType:
                                                      AnimType.bottomSlide,
                                                  showCloseIcon: false,
                                                  title: "Confirm Delete",
                                                  btnOkOnPress: () async {
                                                    _delete(
                                                        documentSnapshot.id);
                                                  },
                                                  btnCancelOnPress: () {})
                                              .show(),
                                          icon: const Icon(Icons.delete),
                                        )
                                      : Text(
                                          "- " + documentSnapshot['Name'],
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${documentSnapshot['Date']} ${documentSnapshot['Time']}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
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
