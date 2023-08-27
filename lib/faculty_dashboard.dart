import 'package:clg_project/student_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class faculty_dashboard extends StatelessWidget {
  const faculty_dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    height: 150,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            foregroundImage:
                                AssetImage("assets/images/ex_img.png"),
                          ),
                          Text(
                            "Vipul M",
                            style: TextStyle(fontSize: 20),
                          ),
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
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => add_student(),));
                            },
                            iconSize: 50,
                            icon: Icon(
                              FontAwesomeIcons.userGraduate,
                              color: Color(0xff002233),
                            ),
                          ),
                          Text(
                            "Students",
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
                            icon: Icon(FontAwesomeIcons.calendarDay,
                                color: Color(0xff002233)),
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
                            icon: Icon(FontAwesomeIcons.filePen,
                                color: Color(0xff002233)),
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
                            icon: Icon(FontAwesomeIcons.fileContract,
                                color: Color(0xff002233)),
                          ),
                          Text(
                            "Results",
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
                            icon: Icon(FontAwesomeIcons.book,
                                color: Color(0xff002233)),
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
                            icon: Icon(FontAwesomeIcons.newspaper,
                                color: Color(0xff002233)),
                          ),
                          Text(
                            "News & Events",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
