import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:clg_project/storage_service.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FilesUpload extends StatefulWidget {
  String _user;

  FilesUpload(this._user, {super.key});

  @override
  State<FilesUpload> createState() => _FilesUploadState();
}

class _FilesUploadState extends State<FilesUpload> {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageService service = StorageService();

  StorageService storageService = StorageService();
  double? _progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        .pickFiles(allowMultiple: true, type: FileType.any);
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
                    return Card(
                      child: ListTile(
                          title: Text(snapshot.data!.items[index].name),
                          trailing: widget._user == "Student"
                              ? IconButton(
                                  onPressed: () {
                                    var url = firebaseStorage
                                        .ref('Files/' +
                                            snapshot.data!.items[index].name)
                                        .getDownloadURL()
                                        .then((url) {
                                      var downurl = url;
                                      FileDownloader.downloadFile(
                                        url: downurl,
                                        onProgress: (name, progress) {
                                          setState(() {
                                            _progress = progress;
                                          });
                                        },
                                        onDownloadCompleted: (value) {
                                          print('file $value');
                                          setState(() {
                                            _progress = null;
                                          });
                                        },
                                        notificationType: NotificationType.all,
                                      );
                                      Duration(seconds: 5);
                                      Fluttertoast.showToast(
                                          msg: 'Downloading....',
                                          toastLength: Toast.LENGTH_LONG);
                                    });
                                  },
                                  icon: Icon(Icons.download),
                                )
                              : IconButton(
                                  onPressed: () {
                                    var url = firebaseStorage
                                        .ref('Files/' +
                                            snapshot.data!.items[index].name)
                                        .getDownloadURL()
                                        .then((url) {
                                      var downurl = url;
                                      print(downurl);
                                      firebaseStorage.ref('Files/').child('Files/'+downurl).delete().then((_){print('delete');});
                                      Duration(seconds: 5);
                                      Fluttertoast.showToast(
                                          msg: 'Downloading....',
                                          toastLength: Toast.LENGTH_LONG);
                                    });
                                  },
                                  icon: Icon(Icons.delete))),
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
