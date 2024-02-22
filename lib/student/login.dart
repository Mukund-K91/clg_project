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
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _login(String enteredUserId, String password) async {
    final String userId = _userIdController.text;
    final String password = _passwordController
        .text; // assuming _mobile is your TextEditingController for the mobile number
// Query Firestore to get the user IDs
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('student').get();
    bool isUserAuthenticated = false;
    if (_formKey.currentState!.validate()) {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        final userData = document.data();
        final String documentUserId = document.id;
        final String mobile = userData?['Mobile'];

        // Check if the document userId (user ID) matches the entered userId and mobile number matches the entered mobile number
        if (documentUserId == userId && mobile == password) {
          final String firstName = userData?['First Name'];
          final String lastName = userData?['Last Name'];

          // Now you have the data from the user ID document, you can use it as needed
          print('First Name: $firstName');
          print('Last Name: $lastName');
          print('Mobile: $mobile');

          // Set isUserAuthenticated to true since the user ID and mobile number exist
          isUserAuthenticated = true;
          break;
        }
      }
      // ignore: use_build_context_synchronously
      if (isUserAuthenticated) {
        // User authenticated successfully, navigate to the main application screen
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            showCloseIcon: false,
            title: "Login Successfully",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainDashboard(widget._User, userId),
                  ));
            }).show();
      }
      // ignore: use_build_context_synchronously
      else {
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
                title: "${widget._User} Not Found",
                desc: widget._User == "Student"
                    ? "Please check userId or Password "
                    : "Please check userId or Password "
                        "Contact Admin for any query")
            .show();
      }
    }
  }

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      ReusableTextField(
                        validator: (str) {
                          if (str!.isEmpty) {
                            return "User Id is required for login";
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
                        controller: _userIdController,
                        label:
                            widget._User == 'Student' ? 'STUDENT ID' : 'Emp Id',
                        enable: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReusableTextField(
                        label: 'PASSWORD',
                        obSecure: passwordObscured,
                        controller: _passwordController,
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
                      Reusablebutton(
                        onPressed: () async {
                          _login(
                              _userIdController.text, _passwordController.text);
                        },
                        Style: false,
                        child: const Text(
                          "LOGIN ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
