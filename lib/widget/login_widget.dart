import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_app/pages/LargePages/Search_Page.dart';

class Login extends StatefulWidget {
  double xX = 0;
  double yY = 0;
  String text1, text2, validation1, validation2;
  Login(this.xX, this.yY, this.text1, this.text2, this.validation1,
      this.validation2,
      {super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Log In",
          style: GoogleFonts.acme(fontSize: widget.yY * 0.05),
        ),
        Container(
          height: widget.yY * .6,
          width: widget.xX * .3,
          child: Column(
            children: [
              SizedBox(
                height: widget.yY * .05,
              ),
              CircleAvatar(
                backgroundImage: AssetImage(
                  "/Images/ic.png",
                ),
                radius: widget.yY * .045,
              ),
              Text(widget.text1),
              SizedBox(
                height: widget.yY * .07,
              ),
              SizedBox(
                width: widget.xX * .25,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.yY * 0.01),
                  ),
                  color: Color.fromARGB(255, 204, 203, 203),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.xX * 0.01,
                          vertical: widget.yY * 0.005),
                      child: TextFormField(
                        controller: username,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter username',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: widget.xX * .25,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.yY * 0.01),
                  ),
                  color: Color.fromARGB(255, 204, 203, 203),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.xX * 0.01,
                          vertical: widget.yY * 0.005),
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter Password',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: widget.yY * 0.1,
              ),
              FloatingActionButton.extended(
                hoverColor: Colors.green,
                onPressed: () {
                  if (username.text == widget.validation1 &&
                      password.text == widget.validation2) {
                    Get.to(SearchPage());
                  } else {
                    Get.snackbar(
                      "Invalid User Input",
                      "Try again",
                      maxWidth: widget.xX * .3,
                      backgroundColor: Colors.redAccent.withOpacity(.9),
                      icon: Icon(Icons.person, color: Colors.black),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.xX * .05),
                  child: Text(widget.text2),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
