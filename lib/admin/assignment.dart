import 'package:clg_project/demo.dart';
import 'package:flutter/material.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  String selectedValue = 'Item 1';

// bakinu pachhi karu !!!!!!!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: Color(0xff225779),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/arrow.png'),
                Text(
                  'Create Assignment',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
                SizedBox(
                  width: 40,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: DropdownButton<String>(
                  value: selectedValue,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 10,
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Item 1',
                      child: Text('Item 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Item 2',
                      child: Text('Item 2'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Item 3',
                      child: Text('Item 3'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Item 4',
                      child: Text('Item 4'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
