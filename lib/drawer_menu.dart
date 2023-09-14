import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Drawer_code extends StatelessWidget {
  String user;
  var email;

  Drawer_code(this.user, this.email);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print(email);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('students').where('Email' isEqualTo: email),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return
          ListView(
          children: snapshot.data!.docs.map((document) {
            return email==document['Email'] ?document[] :
              // ListTile(
              //   leading: CircleAvatar(
              //     child: Text(
              //       document["Div"],
              //       style: TextStyle(
              //           fontSize: 25,
              //           color: Color(0xff002233),
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              //   title: Text(
              //     document["First Name"] + document["Last Name"],
              //     style: TextStyle(fontSize: 20),
              //   ),
              //   subtitle: Text(document["SP ID"]),
              //   trailing: IconButton(
              //       iconSize: 20,
              //       onPressed: () {},
              //       icon: FaIcon(FontAwesomeIcons.pen)));
          }).toList(),
        );
      },
    );
  }
}
