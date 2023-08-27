import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class add_student extends StatelessWidget {
  const add_student({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "STUDENTS",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff002233),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => student_add_form(),
                    ));
              },
              icon: Icon(
                FontAwesomeIcons.add,
                size: 35,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    foregroundImage: AssetImage("man.png"),
                  ),
                  title: Text("Mukund"),
                  subtitle: Text("TYBCA-C"),
                  trailing: IconButton(
                      onPressed: () {}, icon: Icon(FontAwesomeIcons.pen))),
            ],
          )
        ],
      ),
    );
  }
}

class student_add_form extends StatelessWidget {
  const student_add_form({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD Students"),
      ),
    );
  }
}
