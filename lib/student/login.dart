import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  var _user;

  Login(this._user);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordObscured = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String email = _email.text;
        final String password = _password.text;
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            showCloseIcon: false,
            title: "Login Successfully :)",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(widget._user, email),
                  ));
            }).show();
      } catch (error) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                showCloseIcon: true,
                btnOkOnPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeMain(),
                      ));
                },
                title: "${widget._user} Not Found",
                desc: widget._user == "Student"
                    ? "Please contact your respective faculty for Register yourself in eCollege App"
                    : "Please contact admin for Register yourself in eCollege App")
            .show();
      }
    }
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
              const SizedBox(
                height: 150,
              ),
              const Text(
                "Let's Sign in",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
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
                        controller: _email,
                        decoration: InputDecoration(
                            labelText: "Email ID",
                            labelStyle: const TextStyle(fontSize: 15),
                            prefixIcon: widget._user == "Student"
                                ? const Icon(FontAwesomeIcons.userGraduate,
                                    color: Color(0xff002233))
                                : const Icon(
                                    FontAwesomeIcons.userTie,
                                    color: Color(0xff002233),
                                  ),
                            border: const OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Register Email Id is required for login";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _password,
                        obscureText: passwordObscured,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                            labelText: "PASSWORD",
                            labelStyle: const TextStyle(fontSize: 15),
                            prefixIcon: const Icon(
                              Icons.fingerprint,
                              color: Color(0xff002233),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordObscured = !passwordObscured;
                                });
                              },
                              icon: passwordObscured
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            border: const OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required for login";
                          }
                          return null;
                        },
                      ),
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
                              backgroundColor: const Color(0xff002233),
                            ),
                            onPressed: _login,
                            child: const Text(
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
// Future<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchDataByEmail(
//     String email) {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   try {
//     Future<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot =
//     firestore
//         .collection('students')
//         .where('SP ID', isEqualTo:)
//         .get()
//         .then((querySnapshot) {
//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot
//             .docs[0]; // Assuming there's only one matching document
//       } else {
//         throw Exception('No document found with the given email.');
//       }
//     });
//     return documentSnapshot;
//   } catch (e) {
//     print('Error fetching data: $e');
//     return null;
//   }
// }
