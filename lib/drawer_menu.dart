import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Drawer_code extends StatelessWidget {
  Drawer_code({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Color(0xff002233)),
          margin: EdgeInsets.all(0),
          accountName: Text("MUKUND"),
          accountEmail: Text("support@ecollege.com"),
          currentAccountPicture: CircleAvatar(
            foregroundImage: AssetImage('assets/images/ex_img.png'),
          ),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.home, color: Color(0xff002233)),
          title: Text(
            "HOME",
          ),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.user, color: Color(0xff002233)),
          title: Text("PROFILE"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.gear, color: Color(0xff002233)),
          title: Text("SETTINGS"),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            "Contact us",
            style: TextStyle(fontSize: 15),
          ),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.phone, color: Color(0xff002233)),
          title: Text("78XXXXXX77"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.globe, color: Color(0xff002233)),
          title: Text("ecollege.net"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.location, color: Color(0xff002233)),
          title: Text("Suart"),
        ),
        TextButton(
            onPressed: () {},
            child: Text(
              "Log Out !",
              style: TextStyle(fontSize: 15),
            ))
      ],
    );
    ;
  }
}
