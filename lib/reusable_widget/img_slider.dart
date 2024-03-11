import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ImgSlider(BuildContext context) {
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance.collection('slider_data').get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final List<String> imageUrls = snapshot.data!.docs.map((doc) {
        return doc['imageUrl'] as String;
      }).toList();

      return Container(
        width: MediaQuery.of(context).size.width, // Set container width to screen width
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 10,
            viewportFraction: 1.0, // Set viewportFraction to 1.0 to occupy full width
            enlargeCenterPage: true,
            autoPlay: true,
          ),
          items: imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width, // Set image width to screen width
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      );
    },
  );
}