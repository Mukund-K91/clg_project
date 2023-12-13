import 'dart:async';

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
  final TextEditingController _searchController = TextEditingController();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageService service = StorageService();

  StorageService storageService = StorageService();
  double? _progress;

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  bool isSearchClicked = false;
  @override
  String searchText = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Material",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          widget._user == "Student"
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: IconButton(
                    icon: Icon(
                      isSearchClicked ? Icons.close : Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearchClicked = !isSearchClicked;
                      });
                    },
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
                      Timer(Duration(seconds: 5), () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => super.widget,
                            ));
                      });
                    }
                  },
                  icon: const Icon(size: 30, Icons.add),
                  color: Colors.white,
                )
        ],
        backgroundColor: const Color(0xff002233),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: Stack(children: [
          FutureBuilder(
            future: storageService.listFiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (snapshot.hasData) {
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
                                          notificationType:
                                              NotificationType.all,
                                        );
                                        Fluttertoast.showToast(
                                            msg: 'Downloading....',
                                            toastLength: Toast.LENGTH_SHORT);
                                        Timer(Duration(seconds: 4), () {
                                          Fluttertoast.showToast(
                                              msg: 'Downloaded',
                                              toastLength: Toast.LENGTH_LONG);
                                        });
                                      });
                                    },
                                    icon: const Icon(Icons.download),
                                  )
                                : const Icon(
                                    Icons.picture_as_pdf,
                                    color: Color(0xff002233),
                                  )),
                      );
                    });
              }
              return const Text("Some error occurred");
            },
          ),
        ]),
      ),
    );
  }
}
