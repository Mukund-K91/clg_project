import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class dashboard extends StatelessWidget {
  const dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                FontAwesomeIcons.bars,
                color: Colors.white,
              )),
        ),
        title: Text(
          "DASHBOARD",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff002233),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
                child: Container(
              color: Color(0xff002233),
            )),
            ListTile(
              leading: Icon(FontAwesomeIcons.home,color: Color(0xff002233)),
              title: Text("HOME",),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.user,color: Color(0xff002233)),
              title: Text("PROFILE"),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.gear,color: Color(0xff002233)),
              title: Text("SETTINGS"),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Contact us",style: TextStyle(fontSize: 15),),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.phone,color: Color(0xff002233)),
              title: Text("78XXXXXX77"),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.globe,color: Color(0xff002233)),
              title: Text("ecollege.net"),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.location,color: Color(0xff002233)),
              title: Text("Suart"),
            ),
            TextButton(onPressed: (){}, child: Text("Log Out!"))
          ],
        ),
      ),
    );
  }
}
