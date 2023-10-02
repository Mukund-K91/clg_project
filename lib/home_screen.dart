import 'package:clg_project/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'list_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StorageService service = StorageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform
                    .pickFiles(allowMultiple: false, type: FileType.any);
                if (result == null) {
                  print("Error: No file selected");
                } else {
                  final path = result.files.single.path;
                  final fileName = result.files.single.name;
                  service.uplaodFile(fileName, path!);
                }
              },
              child: Text("Upload ")),
          ElevatedButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListScreen()));
              },
              child: Text("Move to List ")),
        ],
      )),
    );
  }
}
