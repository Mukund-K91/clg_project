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
          iconTheme: IconThemeData(color: Colors.white, size: 25),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
          toolbarHeight: 150,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80))),
          centerTitle: true,
          title: Text(
            "Profile",
          ),
          backgroundColor: Color(0xff002233),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
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
                  child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          foregroundImage: NetworkImage(ProfileUrl),
                        ),
                        SizedBox(height: 18),
                        Text(
                          Name,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5),
                        Text(
                          userData['User Id'],
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                          indent: 25,
                          endIndent: 25,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Personal Details',
                            style:
                                TextStyle(fontSize: 20, color: Colors.blueGrey),
                          ),
                        ),
                        ListItem(
                          title: 'Program',
                          subtitle: userData['program'],
                          icon: Icon(
                            FontAwesomeIcons.buildingColumns,
                            color: Colors.white,
                          ),
                        ),
                        ListItem(
                          title: 'Program Term',
                          subtitle: userData['programTerm'],
                          icon: Icon(
                            FontAwesomeIcons.layerGroup,
                            color: Colors.white,
                          ),
                        ),
                        ListItem(
                          title: 'Division',
                          subtitle: userData['division'],
                          icon: Icon(
                            FontAwesomeIcons.sitemap,
                            color: Colors.white,
                          ),
                        ),
                        ListItem(
                          title: 'DOB',
                          subtitle: userData['DOB'],
                          icon: Icon(
                            FontAwesomeIcons.calendarDays,
                            color: Colors.white,
                          ),
                        ),
                        ListItem(
                          title: 'Gender',
                          subtitle: userData['Gender'],
                          icon: Icon(
                            userData['Gender']=="Male"?FontAwesomeIcons.male:FontAwesomeIcons.female,
                            color: Colors.white,
                          ),
                        ),
                        ListItem(
                          title: 'Mobile',
                          subtitle: userData['Mobile'],
                          icon: Icon(
                            FontAwesomeIcons.phone,
                            color: Colors.white,
                          ),
                        ),
                        ListItem(
                          title: 'Email',
                          subtitle: userData['Email'],
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.white,
                          ),
                        ),
                        ListItem(
                          title: 'Activation Date',
                          subtitle: userData['Activation Date'],
                          icon: Icon(
                            FontAwesomeIcons.addressCard,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30,)
                      ],
                    ),
                  )
                ],
              ));
            }
          },
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final String subtitle;

  final Icon? icon;

  ListItem({
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
            color: Color(0xff225779), borderRadius: BorderRadius.circular(14)),
        child: icon,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.grey),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
