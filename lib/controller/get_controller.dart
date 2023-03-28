import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextContoller extends GetxController {
  String? role = "NA";
  String? spec = "NA";
  TextEditingController con = TextEditingController();
  textFieldController(String name) {
    con.text = name;
    print(con.text);
    update();
  }

  roleModel(String? value) {
    role = value;
    spec = null;
    update();
  }

  specModel(String? value) {
    spec = value;
    update();
  }
}
