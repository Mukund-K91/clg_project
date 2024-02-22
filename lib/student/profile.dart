import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  String _UserId;
  Profile(this._UserId, {super.key});



  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Map<String, dynamic>?> profileData(String enteredUserId) async {
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
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    Color themeColor = Color(0xff002233);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff002233),
          title: const Text('PROFILE'),
        ),
        body:  FutureBuilder<Map<String, dynamic>?>(
          future: profileData(widget._UserId),
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
              final String program = userData['program'] +
                  " | " +
                  userData['programTerm'] +
                  " | " +
                  userData['division'];
              final String ProfileUrl = userData['Profile Img'];
              return SingleChildScrollView(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Stack(children: [
                          const CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  AssetImage('assets/images/profile_img2.png')),
                          Positioned(
                              top: 100,
                              left: 100,
                              child: Icon(Icons.camera_alt))
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.idCardClip,
                            color: themeColor,
                          ),
                          title: Text(
                           userData['User Id'],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.solidUser,
                            color: themeColor,
                          ),
                          title: Text(
                            '${Name}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.graduationCap,
                            color: themeColor,
                          ),
                          title: Text(
                            '${program}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.phone,
                            color: themeColor,
                          ),
                          title: Text(
                            '${userData['Mobile']}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.solidEnvelope,
                            color: themeColor,
                          ),
                          title: Text(
                            '${userData['Email']}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        TextButton(
                            onPressed: () {
                              try {
                                final String email = widget._UserId;
                                _auth.sendPasswordResetEmail(email: email);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  title: "Reset Password Mail Sent",
                                  desc:
                                      "New Password Email sent to ${widget._UserId}! Please Check Inbox",
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
                            child: const Text("FORGOT PASSWORD??")),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff002233),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeMain(),
                                    ));
                                runApp(MaterialApp(
                                  home: HomeMain(),
                                  color: const Color(0xff002233),
                                  debugShowCheckedModeBanner: false,
                                  theme: ThemeData(
                                    colorScheme: ColorScheme.fromSeed(
                                        seedColor: const Color(0xff002233)),
                                    useMaterial3: true,
                                  ),
                                ));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.powerOff),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('LOG OUT!'),
                                  )
                                ],
                              )),
                        ),
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
