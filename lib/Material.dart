import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:clg_project/storage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FilesUpload extends StatefulWidget {
  String _user;

  FilesUpload(this._user, {super.key});

  @override
  State<FilesUpload> createState() => _FilesUploadState();
}

class _FilesUploadState extends State<FilesUpload> {
  StorageService service = StorageService();

  StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.file_copy_rounded,
          color: Colors.white,
        ),
        title: Text(
          "Material",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          widget._user == "Student"
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              : IconButton(
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
                  icon: Icon(size: 30, Icons.add),
                  color: Colors.white,
                )
        ],
        backgroundColor: const Color(0xff002233),
      ),
      body: Stack(children: [
        FutureBuilder(
          future: storageService.listFiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.items.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: 'Downloaded',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: Color(0xff002233),
                            textColor: Colors.white,
                            fontSize: 20);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data!.items[index].name),
                        ),
                      ),
                    );
                  });
            }
            return Text("Some error occurred");
          },
        ),
      ]),
    );
  }
}
