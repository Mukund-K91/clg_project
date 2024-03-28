// ignore_for_file: non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_project/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_main.dart';
import '../main.dart';
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

  Future<void> _forgotPassword() async {
    bool _otpSent = false;
    TextEditingController _otpController = TextEditingController();

    final String _collectionGroup =
        widget._UserType == "Student" ? "student" : "faculty";
    // Query Firestore to get the user IDs
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collectionGroup(_collectionGroup)
            .get();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Forgot Password"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Enter your registered User Id & mobile number"),
                      TextFormField(
                        controller: _userIdController2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter registered User Id';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'User ID',
                        ),
                      ),
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter registered mobile number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                        ),
                      ),
                      SizedBox(height: 10),

                      if (_otpSent) OTPField(otpController: _otpController),
                      // Display OTP field conditionally
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey1.currentState!.validate()) {
                            // Check if the entered user ID and mobile exist in Firestore
                            final String enteredUserId =
                                _userIdController2.text;
                            final String enteredMobile = _mobileController.text;

                            bool isUserExists = false;

                            for (final QueryDocumentSnapshot<
                                    Map<String, dynamic>> document
                                in querySnapshot.docs) {
                              final userData = document.data();
                              final String documentUserId = document.id;
                              final String? mobile = userData['Mobile'];

                              // Check if the document userId (user ID) matches the entered userId and mobile number matches the entered mobile number
                              if (documentUserId == enteredUserId &&
                                  mobile == enteredMobile) {
                                isUserExists = true;
                                break;
                              }
                            }

                            if (isUserExists) {
                              // Send OTP logic
                              // Implement logic to send OTP to mobile number
                              // For simplicity, let's assume OTP sent successfully
                              setState(() {
                                _otpSent = true; // Update _otpSent to true
                              });
                            } else {
                              // User not found in Firestore
                              print('User not found');
                            }
                          }
                        },
                        child: Text(_otpSent ? 'Resend OTP' : 'Send OTP'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          if (_otpSent) {
                            // Verify OTP logic
                            String otp = _otpController.text;
                            // Implement OTP verification logic
                            // For simplicity, let's assume OTP verification successful
                            // Show dialog for entering new password
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Reset Password"),
                                  content: SingleChildScrollView(
                                    child: Form(
                                      key: _formKey2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Enter New Password"),
                                          TextFormField(
                                            controller: _newPasswordController,
                                            obscureText: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter new password';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'New Password',
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextFormField(
                                            controller:
                                                _confirmPasswordController,
                                            obscureText: true,
                                            validator: (value) {
                                              if (value !=
                                                  _newPasswordController.text) {
                                                return 'Passwords do not match';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Confirm Password',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.popUntil(
                                            context,
                                            (route) => route
                                                .isFirst); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_formKey2.currentState!
                                            .validate()) {
                                          // Implement logic to update password in Firestore
                                          final String enteredUserId = _userIdController2.text;
                                          final String newPassword = _newPasswordController.text;

                                          try {
                                            // Query Firestore to find the document with the entered user ID
                                            final QuerySnapshot<Map<String, dynamic>> querySnapshot =
                                            await FirebaseFirestore.instance.collectionGroup(_collectionGroup).get();

                                            // Loop through the query snapshot to find the document with the entered user ID
                                            for (final QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
                                            in querySnapshot.docs) {
                                              final String userId = docSnapshot.id;

                                              // Check if the user ID in the document matches the entered user ID
                                              if (userId == enteredUserId) {
                                                // Update the 'Password' field for the found document
                                                await docSnapshot.reference.update({
                                                  'Password': newPassword,
                                                });

                                                // Password updated successfully
                                                _showSuccessDialog();
                                                return; // Exit the loop once the document is found and updated
                                              }
                                            }

                                            // If the loop completes without finding the document, the user ID doesn't exist
                                            print("Document does not exist for user ID: $enteredUserId");
                                          } catch (error) {
                                            // Handle any errors that occur during the update process
                                            print("Error updating password: $error");
                                          }



                                        }
                                      },
                                      child: Text('Submit'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context,
                            (route) => route.isFirst); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    ).then((_) {
      _mobileController.clear();
      _userIdController2.clear();
      _otpController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Password updated successfully"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.isFirst); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                          onPressed: _forgotPassword,
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

class OTPField extends StatefulWidget {
  final TextEditingController otpController;

  const OTPField({
    Key? key,
    required this.otpController,
  }) : super(key: key);

  @override
  _OTPFieldState createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text("Enter OTP"),
        TextFormField(
          controller: widget.otpController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter OTP';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'OTP',
          ),
        ),
      ],
    );
  }
}
