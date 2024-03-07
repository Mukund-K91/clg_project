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
              return Text("Remove this text widget and start building profile after return word ");
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
