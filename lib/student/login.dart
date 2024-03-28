// ignore_for_file: non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_project/reusable_widget/forgot_password.dart';
import 'package:clg_project/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reusable_widget/reusable_textfield.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _UserType;

  const Login(this._UserType, {super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordObscured = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _mobileController =
      TextEditingController();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _newPasswordController =
      TextEditingController();
  TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userIdController2 =
      TextEditingController();
  bool _otpSent = false;
  

  Future<void> _login(
      String enteredUserId, String password, String userType) async {
    final String userId = _userIdController.text;
    final String password = _passwordController.text;
    final String _collectionGroup =
        userType == "Student" ? "student" : "faculty";
    // Query Firestore to get the user IDs
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collectionGroup(_collectionGroup)
            .get();
    bool isUserAuthenticated = false;

    if (_formKey.currentState!.validate()) {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        final userData = document.data();
        final String documentUserId = document.id;
        final String documentPassword = userData?['Password'];

        // Check if the document userId (user ID) matches the entered userId and password matches the entered password
        if (documentUserId == userId && documentPassword == password) {
          final String firstName = userData?['First Name'];
          final String lastName = userData?['Last Name'];

          // Now you have the data from the user ID document, you can use it as needed
          print('First Name: $firstName');
          print('Last Name: $lastName');
          print('Password: $documentPassword');

          // Set isUserAuthenticated to true since the user ID and password exist
          isUserAuthenticated = true;
          break;
        }
      }

      if (isUserAuthenticated) {
        Center(
          child: CircularProgressIndicator(),
        );
        AwesomeDialog(
          dismissOnTouchOutside: false,
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          showCloseIcon: false,
          title: "Login Successfully",
          btnOkOnPress: () async {
            var sharedPref = await SharedPreferences.getInstance();
            sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
            sharedPref.setString(SplashScreenState.KEYUSERNAME, enteredUserId);
            sharedPref.setString(
                SplashScreenState.KEYUSERTYPE, widget._UserType);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainDashboard(userType, userId),
              ),
              (_) => false,
            );
          },
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          dismissOnTouchOutside: false,
          showCloseIcon: true,
          title: "$userType Not Found",
          desc: "Please check userId or Password. Contact Admin for any query",
        ).show();
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
                        keyboardType: widget._UserType=="Student"?TextInputType.phone:TextInputType.text,
                        preIcon: widget._UserType == "Student"
                            ? const Icon(FontAwesomeIcons.userGraduate,
                                color: Color(0xff002233))
                            : const Icon(
                                FontAwesomeIcons.userTie,
                                color: Color(0xff002233),
                              ),
                        controller: _userIdController,
                        title: widget._UserType == 'Student'
                            ? 'STUDENT ID'
                            : 'Emp Id',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReusableTextField(
                        title: 'PASSWORD',
                        obSecure: passwordObscured,
                        controller: _passwordController,
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: ()=>ForgotPasswordDialog.show(context, widget._UserType),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Color(0xff4b8bfb)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Reusablebutton(
                        onPressed: () async {
                          _login(_userIdController.text,
                              _passwordController.text, widget._UserType);
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


