import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key, required this.imageUrls});
  final List<String> imageUrls;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FullScreenImagePage(
            imageUrls: widget.imageUrls,
            initialIndex: _currentIndex,
          ),
        ));
      },
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: widget.imageUrls.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrls[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
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
              onPageChanged: (index, _) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  const FullScreenImagePage(
      {super.key, required this.imageUrls, required this.initialIndex});
  final List<String> imageUrls;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Image'),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return Center(
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
