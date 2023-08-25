import 'package:clg_project/dashboard.dart';
import 'package:clg_project/faculty_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class login extends StatelessWidget {
  var _txtfield;

  login(this._txtfield);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/login_bg.png"))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's Sign in",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Welcome Back,\nYou've been missed..",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(
              height: 25,
            ),
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: _txtfield,
                      labelStyle: TextStyle(fontSize: 15),
                      prefixIcon: _txtfield == "SP ID"
                          ? Icon(FontAwesomeIcons.userGraduate,
                              color: Color(0xff002233))
                          : Icon(
                              FontAwesomeIcons.userTie,
                              color: Color(0xff002233),
                            ),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(fontSize: 15),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xff002233),
                      ),
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Color(0xff002233),
                      ),
                      border: OutlineInputBorder()),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {}, child: Text("Reset Password?"))),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Color(0xff002233),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _txtfield == "SP ID"
                                  ? dashboard()
                                  : faculty_dashboard(),
                            ));
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
              ],
            ))
          ],
        ),
      ),
    ));
  }
}
