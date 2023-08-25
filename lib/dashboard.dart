import 'package:clg_project/drawer_menu.dart';
import 'package:clg_project/faculty_dashboard.dart';
import 'package:clg_project/student_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class dashboard extends StatelessWidget {
  var _id;

  dashboard(this._id)
  {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) =>
                IconButton(
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
          child: Drawer_code(),
        ),
        body:_id=="SP ID"?student_dashboard():faculty_dashboard()
    );
  }
}
