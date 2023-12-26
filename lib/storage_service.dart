import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<void> uplaodFile(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      await firebaseStorage.ref('Files/$fileName').putFile(file).then((p0) {
        log("Uploaded");
      });
    } catch (e) {
      log("Error: $e");
    }
  }
  Future<ListResult> listFiles() async {
    ListResult listResults = await firebaseStorage.ref('Files').listAll();
    return listResults;
  }
}
