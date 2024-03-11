// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class CarouselFile extends StatefulWidget {
//   const CarouselFile({super.key, required this.selectedImages});
//   final List<XFile?> selectedImages;

//   @override
//   _CarouselFileState createState() => _CarouselFileState();
// }

// class _CarouselFileState extends State<CarouselFile> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final List<String> imageUrls =
//         widget.selectedImages.map((element) => element.toString()).toList();
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => FullScreenImagePage(
//             imageUrls: imageUrls,
//             initialIndex: _currentIndex,
//           ),
//         ));
//       },
//       child: Column(
//         children: [
//           CarouselSlider.builder(
//             itemCount: imageUrls.length,
//             itemBuilder: (BuildContext context, int index, int realIndex) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   image: DecorationImage(
//                     image: NetworkImage(imageUrls[index]),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             },
//             options: CarouselOptions(
//               height: 280.0,
//               enlargeCenterPage: true,
//               autoPlay: true,
//               aspectRatio: 16 / 9,
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enableInfiniteScroll: true,
//               autoPlayAnimationDuration: const Duration(milliseconds: 800),
//               viewportFraction: 0.8,
//               onPageChanged: (index, _) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FullScreenImagePage extends StatelessWidget {
//   const FullScreenImagePage(
//       {super.key, required this.imageUrls, required this.initialIndex});
//   final List<String> imageUrls;
//   final int initialIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Full Screen Image'),
//       ),
//       body: PageView.builder(
//         itemCount: imageUrls.length,
//         controller: PageController(initialPage: initialIndex),
//         itemBuilder: (context, index) {
//           return Center(
//             child: Image.asset(
//               imageUrls[index],
//               fit: BoxFit.cover,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
