import 'package:clg_project/drawer_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class dashboard extends StatelessWidget {
  dashboard({super.key});

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
          child: Drawer_code(),
        ),
        body: Stack(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Color(0xff002233),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              foregroundImage:
                                  AssetImage("assets/images/ex_img.png"),
                            ),
                            Text(
                              "MUKUND K",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("TYBCA-C")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              iconSize: 50,
                              icon: Icon(FontAwesomeIcons.calendarDay,color: Color(0xff002233),),
                            ),
                            Text(
                              "Attendence",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              iconSize: 50,
                              icon: Icon(FontAwesomeIcons.book,color: Color(0xff002233)),
                            ),
                            Text(
                              "Syllabus",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              iconSize: 50,
                              icon: Icon(FontAwesomeIcons.filePen,color: Color(0xff002233)),
                            ),
                            Text(
                              "Assignment",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              iconSize: 50,
                              icon: Icon(FontAwesomeIcons.fileContract,color: Color(0xff002233)),
                            ),
                            Text(
                              "Results",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Text("dfghdfgh"),
                )
              ],
            )
          ],
        ));
  }
}
