import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<void> pagenotfound(BuildContext context, String title) async {
  await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          height: 350,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            const Image(image: AssetImage('assets/images/pagenotfound_img.png')),
        const SizedBox(height: 15),
        Text(title,style: const TextStyle(fontSize: 20,),)
        ],
        ),
        );
      });
}
