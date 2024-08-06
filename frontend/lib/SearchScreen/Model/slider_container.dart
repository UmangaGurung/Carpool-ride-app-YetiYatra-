import 'package:flutter/cupertino.dart';

class SliderContainer extends StatelessWidget {
  String image;
  SliderContainer({super.key, required this.image});

  final List<String> imgList = [
    'images/slider.JPG',
    'images/slidertwo.jpg',
    'images/sliderthree.jpg',
    // Add more images as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage('images/slider.JPG'),
            fit: BoxFit.fill,
          )),
    );
    return Image.asset('images/sliderr.png',fit: BoxFit.cover);
  }
}
