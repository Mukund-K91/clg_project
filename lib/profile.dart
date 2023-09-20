import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatelessWidget {
  String _email;

  Profile(this._email, {super.key});

  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff002233),
          title: const Text('PROFILE'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: fetchDataByEmail(_email),
          // Replace with the desired email
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Column(
                children: [
                  Text('Error: ${snapshot.error} USER NOT FOUND\nplease contact your administrator eCollegeAdmin@gmail.com'),
                  ElevatedButton(
                      onPressed: () {
                        _auth.signOut().then((value) {Navigator.push(context, MaterialPageRoute(builder: (context) => HomeMain(),));});
                      },
                      child: Text('Return Home Page')),
                ],
              );
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('No data found for the given email.');
            } else {
              // Data found, you can access it using snapshot.data
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          minRadius: 80,
                          maxRadius: 80,
                          backgroundColor: Colors.grey,
                          foregroundImage:
                              AssetImage('assets/images/profile_img.png'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.solidUser,
                              color: Colors.black,
                            ),
                            title: const Text(
                              "Name",
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Text(
                                '${data['First Name']} ${data['Last Name']}')),
                        const Divider(
                          thickness: 2,
                        ),
                        ListTile(
                          leading: const Icon(
                            FontAwesomeIcons.graduationCap,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Div",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: Text('TYBCA-${data['Div']}'),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        ListTile(
                          leading: const Icon(
                            FontAwesomeIcons.phone,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Mobile",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: Text('${data['Mobile']}'),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        ListTile(
                          leading: const Icon(
                            FontAwesomeIcons.solidEnvelope,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Mobile",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: Text('${data['Email']}'),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        TextButton(
                            onPressed: () {
                              try {
                                final String email = _email;
                                _auth.sendPasswordResetEmail(email: email);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  title: "Reset Password Mail Sent",
                                  desc:
                                      "New Password Email sent to ${_email}! Please Check Inbox",
                                  showCloseIcon: true,
                                ).show();
                              } catch (error) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  title: "Failed",
                                  showCloseIcon: true,
                                ).show();
                              }
                            },
                            child: Text("FORGOT PASSWORD?")),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeMain(),
                                  ));
                            },
                            child: Text("LOG OUT!"))
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchDataByEmail(
    String email) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    Future<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot =
        firestore
            .collection('students')
            .where('Email', isEqualTo: email)
            .get()
            .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot
            .docs[0]; // Assuming there's only one matching document
      } else {
        throw Exception('No document found with the given email.');
      }
    });

    return documentSnapshot;
  } catch (e) {
    print('Error fetching data: $e');
    return null;
  }

}
