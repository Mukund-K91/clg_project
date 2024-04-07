import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../student/login.dart';

class ForgotPasswordDialog {
  static Future<void> show(BuildContext context, String userType) async {
    final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
    final TextEditingController _userIdController2 = TextEditingController();
    final TextEditingController _mobileController = TextEditingController();
    final TextEditingController _otpController = TextEditingController();
    final TextEditingController _newPasswordController =
    TextEditingController();
    final TextEditingController _confirmPasswordController =
    TextEditingController();
    bool _otpSent = false;

    final String _collectionGroup =
    userType == "Student" ? "student" : "faculty";
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collectionGroup(_collectionGroup).get();

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
                            final String enteredUserId = _userIdController2.text;
                            final String enteredMobile = _mobileController.text;
                            bool isUserExists = false;

                            for (final QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
                              final userData = document.data();
                              final String documentUserId = document.id;
                              final String? mobile = userData['Mobile'];

                              if (documentUserId == enteredUserId && mobile == enteredMobile) {
                                isUserExists = true;
                                break;
                              }
                            }

                            if (isUserExists) {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Reset Password"),
                                      content: SingleChildScrollView(
                                        child: Form(
                                          key: _formKey2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Enter New Password"),
                                              TextFormField(
                                                controller: _newPasswordController,
                                                obscureText: true,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
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
                                                controller: _confirmPasswordController,
                                                obscureText: true,
                                                validator: (value) {
                                                  if (value != _newPasswordController.text) {
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
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_formKey2.currentState!.validate()) {
                                              final String enteredUserId = _userIdController2.text;
                                              final String newPassword = _newPasswordController.text;

                                              try {
                                                final QuerySnapshot<Map<String, dynamic>> querySnapshot =
                                                await FirebaseFirestore.instance.collectionGroup(_collectionGroup).get();

                                                for (final QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot in querySnapshot.docs) {
                                                  final String userId = docSnapshot.id;
                                                  if (userId == enteredUserId) {
                                                    await docSnapshot.reference.update({
                                                      'Password': newPassword,
                                                    });
                                                    showSuccessDialog(context);
                                                    return;
                                                  }
                                                }
                                                print("Document does not exist for user ID: $enteredUserId");
                                              } catch (error) {
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
                              });
                            } else {
                              print('User not found');
                            }
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
    );
  }

  static void showSuccessDialog(BuildContext context) {
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
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}



