
import 'package:clg_project/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class login extends StatefulWidget {
  var _txtfield;

  login(this._txtfield);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool passwordObscured = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => dashboard("SP ID"),
          ));
    }
  }

  final TextEditingController _spid = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/login_bg.png"))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
              ),
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
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _spid,
                        decoration: InputDecoration(
                            labelText: widget._txtfield,
                            labelStyle: TextStyle(fontSize: 15),
                            prefixIcon: widget._txtfield == "Mobile No"
                                ? Icon(FontAwesomeIcons.userGraduate,
                                    color: Color(0xff002233))
                                : Icon(
                                    FontAwesomeIcons.userTie,
                                    color: Color(0xff002233),
                                  ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "SP ID is required for login";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: passwordObscured,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                            labelText: "PASSWORD",
                            labelStyle: TextStyle(fontSize: 15),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xff002233),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordObscured = !passwordObscured;
                                });
                              },
                              icon: passwordObscured
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required for login";
                          }
                          return null;
                        },
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {},
                              child: Text("Reset Password?"))),
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
                            onPressed: _login,
                            child: Text(
                              "LOGIN",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
