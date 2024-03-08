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
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: const BoxDecoration(
                color: Color(0xff225779),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  ),
                  const Text(
                    'Assignment',
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    child: _SampleCard(cardName: "Assignment name"),
                  ),
                  Card(
                    child: _SampleCard(cardName: "Subject name"),
                  ),
                  Card(
                    child: _SampleCard(cardName: "Due date"),
                  ),
                  Card(
                    child: _SampleCard(cardName: "Possible Points"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {},
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

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName});

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardName,
              style: const TextStyle(fontSize: 15),
            ),
            const Text(
              "Example",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
