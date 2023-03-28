import 'dart:js';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagesRE extends StatelessWidget {
  String path, message, message1;
  Color textColor;
  ImagesRE(this.path, this.message, this.message1, this.textColor);
  @override
  Widget build(BuildContext context) {
    double _xX = MediaQuery.of(context).size.width;
    double _yY = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          width: _xX * .5,
          height: _yY,
          child: Image.asset(
            path,
            fit: BoxFit.fill,
            opacity: AlwaysStoppedAnimation(.5),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: GoogleFonts.playfairDisplay(
                  fontSize: _yY * .05,
                  color: textColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              message1,
              style: GoogleFonts.playfairDisplay(
                  fontSize: _yY * .03,
                  color: textColor.withOpacity(.5),
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    );
  }
}

class Carousel_images extends StatefulWidget {
  @override
  State<Carousel_images> createState() => _Carousel_imagesState();
}

class _Carousel_imagesState extends State<Carousel_images> {
  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;
    final List<ImagesRE> images = [
      ImagesRE("/Images/Image3.jpg", "", "", Colors.black12),
      ImagesRE("/Images/doc.jpg", "", "", Colors.black),
    ];
    return Container(
      height: y,
      width: x * 5,
      child: CarouselSlider(
        items: [for (int i = 0; i < images.length; i++) images[i]],
        options: CarouselOptions(
          height: y,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
        ),
      ),
    );
  }
}
