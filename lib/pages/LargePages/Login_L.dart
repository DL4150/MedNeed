import 'package:flutter/material.dart';

import 'package:med_app/widget/SlideShow.dart';
import 'package:med_app/widget/login_widget.dart';

class Login_larger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _xX = MediaQuery.of(context).size.width;
    double _yY = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: _yY,
            width: _xX * .5,
            child: Carousel_images(),
          ),
          Stack(
            children: [
              Container(
                height: _yY,
                width: _xX * .5,
                color: Colors.grey.shade100,
              ),
              Container(
                width: _xX * .5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Login(_xX, _yY, "Hospital", "Login",
                          "gdsc", "great"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
