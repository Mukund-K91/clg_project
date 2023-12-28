import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Assignment extends StatelessWidget {
  const Assignment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('assignments')
      ),
      body: Column(
        children: [
          container(
            decoration: BoxDecoration(
              color: kOthercolor,
              borderRadius:BorderRadius.only(
                topLeft: Radius.circular(kDefaultpadding),
                topRight: Radius.circular(kDefaultpadding),

              ),
            ),
          ),// container
        ],
      ),
    );
  }
}
