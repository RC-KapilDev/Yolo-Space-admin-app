import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarouselFile extends StatelessWidget {
  const CarouselFile({super.key, required this.selectedImages});
  final List<XFile?> selectedImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: selectedImages.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final XFile? xFile = selectedImages[index];
            if (xFile != null) {
              final File imageFile = File(xFile.path);
              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return Container(); // Return an empty container if XFile is null
            }
          },
          options: CarouselOptions(
            height: 280.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
        ),
      ],
    );
  }
}
