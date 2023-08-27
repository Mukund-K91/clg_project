import 'dart:js_interop';

class UserModel {
  final String? id;
  final String? fname;
  final String? lname;
  final String? dob;
  final String? admissiondate;
  final String? mobile;
  final String? email;

  const UserModel({
    this.id,
    required this.fname,
    required this.lname,
    required this.dob,
    required this.admissiondate,
    required this.mobile,
    required this.email,
  });

  toJson() {
    return {
      "First Name": fname,
      "Last Name": lname,
      "DOB": dob,
      "Admission Date": admissiondate,
      "Mobile": mobile,
      "Email-Id": email
    };
  }
}
