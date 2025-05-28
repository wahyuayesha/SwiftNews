import 'package:flutter/material.dart';
import 'package:get/get.dart';

void alert(String title, String message, Function action) {
  Get.defaultDialog(
    title: title,
    titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    middleText: message,
    textConfirm: 'Yes',
    textCancel: 'No',
    confirmTextColor: Colors.white,
    buttonColor: Colors.redAccent,
    onConfirm: () {
      Get.back(); 
      action(); 
    },
    onCancel: () {
      Get.back();
    },
  );
}
