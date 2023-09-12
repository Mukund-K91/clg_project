import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/editable_text.dart';

void crud_add(_fname, _lname,_date,_mobile,_email) {
  CollectionReference collRef =
      FirebaseFirestore.instance.collection('Students');
  collRef.add({'First Name': _fname.text, 'Last Name': _lname});
}
