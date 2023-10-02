import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class btn extends StatelessWidget {
  double btn_height;
  double btn_width;
  String btn_text;

  btn(this.btn_height, this.btn_width, this.btn_text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: btn_width,
        height: btn_height,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            onPressed: () {},
            child: Text(
              btn_text,
              style: TextStyle(color: Color(0xff002233), fontSize: 15),
            )),
      ),
    );
  }
}
