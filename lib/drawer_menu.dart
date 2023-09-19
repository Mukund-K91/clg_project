import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Drawer_code extends StatelessWidget {
  String user;
  var email;

  Drawer_code(this.user, this.email);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController name =TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(email);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: Drawer(
          child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: fetchDataByEmail(email),
            // Replace with the desired email
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('No data found for the given email.');
              } else {
                // Data found, you can access it using snapshot.data
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return
                  UserAccountsDrawerHeader(
                    accountName: Text('${data['First Name']}'),
                    accountEmail: Text(
                        email)); // Replace 'name' with the field you want to display
              }
            },
          ),
        ],
      )),
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
