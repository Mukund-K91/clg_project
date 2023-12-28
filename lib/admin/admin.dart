import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentManage extends StatefulWidget {
  StudentManage({super.key});

  @override
  State<StudentManage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StudentManage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // text field controller
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _rollno = TextEditingController();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _divison = ["Div", "A", "B", "C", "D"];
  String? _selectedDiv = "Div";
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('students');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String searchText = '';

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
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Add Student",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextFormField(
                          //     controller: _id,
                          //     keyboardType: TextInputType.number,
                          //     decoration: const InputDecoration(
                          //       labelText: "SP ID",
                          //       border: OutlineInputBorder(),
                          //     ),
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "SP ID is required";
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),
                          ReusableTextField(
                            controller: _id,
                            keyboardType: TextInputType.number,
                            enable: true,
                            label: 'SP ID',
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "SP ID is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          ReusableTextField(
                            controller: _rollno,
                            label: 'Roll No',
                            keyboardType: TextInputType.phone,
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "Roll No is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _fname,
                            label: 'First Name',
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "First Name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          ReusableTextField(
                            controller: _lname,
                            label: 'Last Name',
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "Last Name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          ReusableTextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            label: 'Email Id',
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "Email is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          ReusableTextField(
                            controller: _mobile,
                            label: 'Mobile No',
                            keyboardType: TextInputType.phone,
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty || str.length > 10) {
                                return "10 Digit no. is required";
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                value: _selectedDiv,
                                items: _divison
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedDiv = val as String;
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: const Color(0xff002233),
                                ),
                                onPressed: () async {
                                  final String email = _email.text;
                                  final String password = _mobile.text;
                                  if (_formKey.currentState!.validate()) {
                                    final credential = await FirebaseAuth
                                        .instance
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password);
                                    await _items.add({
                                      "SP ID": _id.text,
                                      "Roll No":_rollno.text,
                                      "First Name": _fname.text,
                                      "Last Name": _lname.text,
                                      "Mobile": _mobile.text,
                                      "Email": _email.text,
                                      "Password": _mobile.text,
                                      "Div": _selectedDiv
                                    });
                                    _id.text = '';
                                    _rollno.text='';
                                    _fname.text = '';
                                    _lname.text = '';
                                    _email.text = '';
                                    _mobile.text = '';
                                    _selectedDiv = "Div";
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
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
      _id.text = documentSnapshot['SP ID'].toString();
      _rollno.text = documentSnapshot['Roll No'].toString();
      _fname.text = documentSnapshot['First Name'].toString();
      _lname.text = documentSnapshot['Last Name'].toString();
      _email.text = documentSnapshot['Email'].toString();
      _mobile.text = documentSnapshot['Mobile'].toString();
      _selectedDiv = documentSnapshot['Div'].toString();
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
                      "Update Student Info",
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
                            controller: _id,
                            label: 'SP ID',
                            keyboardType: TextInputType.phone,
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "SP ID is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _rollno,
                            label: 'Roll No',
                            keyboardType: TextInputType.phone,
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "Roll No is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _fname,
                            label: 'First Name',
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "First Name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _lname,
                            label: 'Last Name',
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "Last Name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _email,
                            label: 'Email Id',
                            enable: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (str) {
                              if (str!.isEmpty) {
                                return "Email is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),
                          ReusableTextField(
                            controller: _mobile,
                            label: 'Mobile No',
                            enable: true,
                            validator: (str) {
                              if (str!.isEmpty || str.length > 10) {
                                return "10. Digit no. is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                value: _selectedDiv,
                                items: _divison
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedDiv = val as String;
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: const Color(0xff002233),
                                ),
                                onPressed: () async {
                                  await _items
                                      .doc(documentSnapshot!.id)
                                      .update({
                                    "SP ID": _id.text,
                                    "First Name": _fname.text,
                                    "Last Name": _lname.text,
                                    "Mobile": _mobile.text,
                                    "Email": _email.text,
                                    "Password": _mobile.text,
                                    "Div": _selectedDiv
                                  });
                                  _id.text = '';
                                  _fname.text = '';
                                  _lname.text = '';
                                  _email.text = '';
                                  _mobile.text = '';
                                  _selectedDiv = "Div";

                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
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
    // await _items.doc(productID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have successfully deregister Student")));
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
                'Students',
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
        stream: _items.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<DocumentSnapshot> items = streamSnapshot.data!.docs
                .where((doc) => doc['First Name'].toLowerCase().contains(
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
                          documentSnapshot['First Name'] +
                              " " +
                              documentSnapshot['Last Name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      subtitle: Text(
                        documentSnapshot['SP ID'].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                color: Colors.white,
                                onPressed: () => _update(documentSnapshot),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                color: Colors.white,
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
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
      // Create new project button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: const Color(0xff002233),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
