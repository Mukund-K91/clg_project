import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImgSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('slider_data').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<Map<String, dynamic>> imageDataList = snapshot.data!.docs
            .map((doc) => {
          'imageUrl': doc['imageUrl'] as String,
          'endDate': (doc['endDate'] as Timestamp).toDate() // Convert to DateTime
        })
            .toList();

        // Filter images based on end date
        final currentDate = DateTime.now();
        final activeImages = imageDataList.where((data) {
          final endDate = data['endDate'] as DateTime;
          return endDate.isAfter(currentDate) || endDate.isAtSameMomentAs(currentDate);
        }).toList();

        // Manual list of images
        final manualImages = [
          'assets/images/slider_img_1.png',
          'assets/images/slider_img_2.png',
          // Add more manual image asset paths as needed
        ];

        final List<String> items = activeImages.isEmpty ? manualImages : activeImages.map((data) => data['imageUrl'] as String).toList();

        return Container(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 16 / 10,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            items: items.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  // Check if the image is a local asset or a network image
                  if (imageUrl.startsWith('assets')) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
