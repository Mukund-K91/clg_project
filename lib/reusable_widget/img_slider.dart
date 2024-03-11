import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImgSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('slider_data').get(),
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

        return Container(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 16 / 10,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            items: activeImages.map((imageData) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageData['imageUrl'] as String,
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
}
