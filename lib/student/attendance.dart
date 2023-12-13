import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

Random random = new Random();

class _AttendanceState extends State<Attendance> {
  int present = random.nextInt(100);
  int absent =random.nextInt(20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff002233),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                shadowColor: Colors.grey,
                elevation: 5,
                color: Colors.green.shade200,
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Total Present',style: TextStyle(fontSize: 20),),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Text(present.toString(),style: const TextStyle(fontSize: 20),),
                    )
                  ],
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                shadowColor: Colors.grey,
                elevation: 5,
                color: Colors.redAccent.shade200,
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Total Absent',style: TextStyle(fontSize: 20),),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Text(absent.toString(),style: const TextStyle(fontSize: 20),),
                    )
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
