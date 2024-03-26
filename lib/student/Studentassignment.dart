import 'package:clg_project/reusable_widget/reusable_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Studentassignment extends StatefulWidget {
  const Studentassignment({super.key});

  @override
  State<StatefulWidget> createState() => _StudentassignmentState();
}

class _StudentassignmentState extends State<Studentassignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Assignment'),
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Card(
              child: SampleCard(cardName: "Assignment name", cardDes: 'E-COMMERCE AND CYBER SECURITY\n1 to 4',),
            ),
            Card(
              child: SampleCard(cardName: "Subject name", cardDes: 'E-COMMERCE AND CYBER SECURITY',),
            ),
            Card(
              child: SampleCard(cardName: "Due date", cardDes: '25-03-2024',),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              final result = await FilePicker.platform
                  .pickFiles(allowMultiple: true, type: FileType.any);
            },
            backgroundColor: Color(0xff225779),
            tooltip: 'Increment',
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(150)),
            child: const Icon(Icons.cloud_upload_outlined,
                color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class SampleCard extends StatelessWidget {
  const SampleCard({required this.cardName, required this.cardDes,this.color});

  final String cardName;
  final String cardDes;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child:Card(
        color: color,
        child: ListTile(
          title: Text(cardName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(cardDes),
        ),
      )
    );
  }
}
