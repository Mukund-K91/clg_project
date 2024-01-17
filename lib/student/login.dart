// ignore_for_file: non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import '../reusable_widget/reusable_textfield.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _User;

  const Login(this._User, {super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordObscured = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    // if (_formKey.currentState!.validate()) {
    //   try {
    //     final String email = _email.text;
    //     final String password = _password.text;
    //     await _auth.signInWithEmailAndPassword(
    //         email: email, password: password);
    //     // ignore: use_build_context_synchronously
    //     AwesomeDialog(
    //         context: context,
    //         dialogType: DialogType.success,
    //         animType: AnimType.bottomSlide,
    //         showCloseIcon: false,
    //         title: "Login Successfully",
    //         btnOkOnPress: () {
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => Dashboard(widget._User, email),
    //               ));
    //         }).show();
    //   } catch (error) {
    //     // ignore: use_build_context_synchronously
    //     AwesomeDialog(
    //             context: context,
    //             dialogType: DialogType.error,
    //             animType: AnimType.bottomSlide,
    //             showCloseIcon: true,
    //             btnOkOnPress: () {
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => const HomeMain(),
    //                   ));
    //             },
    //             title: "${widget._User} Not Found",
    //             desc: widget._User == "Student"
    //                 ? "Please contact your respective faculty "
    //                     "for Register yourself in eCollege App"
    //                 : "Please contact admin for Register "
    //                     "yourself in eCollege App")
    //         .show();
    //   }
    // }

  }
  Future<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchDataByEmail(
      String email) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      Future<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot =
      firestore
          .collection('students')
          .where('SP ID', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeMain(),));
          print("Done");
          return querySnapshot
              .docs[0]; // Assuming there's only one matching document
        } else {
          print('Fail');
          throw Exception('No document found with the given email.');
        }
      });
      return documentSnapshot;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
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
                      // TextFormField(
                      //   controller: _email,
                      //   decoration: InputDecoration(
                      //       labelText: "Email ID",
                      //       labelStyle: const TextStyle(fontSize: 15),
                      //       prefixIcon: widget._User == "Student"
                      //           ? const Icon(FontAwesomeIcons.userGraduate,
                      //               color: Color(0xff002233))
                      //           : const Icon(
                      //               FontAwesomeIcons.userTie,
                      //               color: Color(0xff002233),
                      //             ),
                      //       border: const OutlineInputBorder()),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "Register Email Id is required for login";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      ReusableTextField(
                        validator: (str) {
                          if (str!.isEmpty) {
                            return "Register Email Id is required for login";
                          }
                          return null;
                        },
                        preIcon: widget._User == "Student"
                            ? const Icon(FontAwesomeIcons.userGraduate,
                                color: Color(0xff002233))
                            : const Icon(
                                FontAwesomeIcons.userTie,
                                color: Color(0xff002233),
                              ),
                        controller: _email,
                        label: 'Email ID',
                        enable: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // TextFormField(
                      //   controller: _password,
                      //   obscureText: passwordObscured,
                      //   obscuringCharacter: '*',
                      //   decoration: InputDecoration(
                      //       labelText: "PASSWORD",
                      //       labelStyle: const TextStyle(fontSize: 15),
                      //       prefixIcon: const Icon(
                      //         Icons.fingerprint,
                      //         color: Color(0xff002233),
                      //       ),
                      //       suffixIcon: IconButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             passwordObscured = !passwordObscured;
                      //           });
                      //         },
                      //         icon: passwordObscured
                      //             ? const Icon(Icons.visibility_off)
                      //             : const Icon(Icons.visibility),
                      //       ),
                      //       border: const OutlineInputBorder()),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "Password is required for login";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      ReusableTextField(
                        label: 'PASSWORD',
                        obSecure: passwordObscured,
                        controller: _password,
                        enable: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required for login";
                          }
                          return null;
                        },
                        preIcon: const Icon(
                          Icons.fingerprint,
                          color: Color(0xff002233),
                        ),
                        sufIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordObscured = !passwordObscured;
                            });
                          },
                          icon: passwordObscured
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
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
                          onPressed: () {
                            fetchDataByEmail(_email.text);
                          },
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // FutureBuilder<DocumentSnapshot>(
                //   future: fetchDataByEmail("2021052569"),
                //   // Replace with the desired email
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (snapshot.hasError) {
                //       return Column(
                //         children: [
                //           Text(
                //               'Error: ${snapshot.error} USER NOT FOUND\nplease contact your administrator eCollegeAdmin@gmail.com'),
                //           ElevatedButton(
                //               onPressed: () {
                //                 _auth.signOut().then((value) {
                //                   Navigator.pushReplacement(
                //                       context,
                //                       MaterialPageRoute(
                //                         builder: (context) => const HomeMain(),
                //                       ));
                //                 });
                //               },
                //               child: const Text('Return Home Page')),
                //         ],
                //       );
                //     } else if (!snapshot.hasData || !snapshot.data!.exists) {
                //       return const Text('No data found for the given email.');
                //     } else {
                //       // Data found, you can access it using snapshot.data
                //       Map<String, dynamic> data =
                //       snapshot.data!.data() as Map<String, dynamic>;
                //       return SingleChildScrollView(
                //         child: Align(
                //           alignment: Alignment.center,
                //           child: Padding(
                //             padding: const EdgeInsets.all(10),
                //             child: Column(
                //               children: [
                //                 ListTile(
                //                   leading: Icon(
                //                     FontAwesomeIcons.idCardClip,
                //                   ),
                //                   title: Text(
                //                     data['First Name'],
                //                     style: const TextStyle(fontSize: 15),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       );
                //     }
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


