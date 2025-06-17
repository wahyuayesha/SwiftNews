import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.deepOrangeAccent; // Warna utama
  static final Color primary08 = Colors.deepOrangeAccent.withOpacity(0.8); // Warna utama dengan transparansi 80% 

  static const Color background = Colors.white;        // Latar belakang aplikasi

  static final Color textFieldBackground = Colors.grey.shade200; // Background TextField dan button 
  static const Color textFieldBorder = Colors.grey;    // Border TextField dan button
  static const Color textColor = Colors.black;        // Warna teks
  static const Color buttonColor = Color.fromRGBO(63, 125, 88, 1);   // Warna button
  static Color lightgrey = Colors.grey.shade100;   // Warna button

  // Error Snackbar
  static const Color errorSnackbar = Colors.red; // Warna snackbar error
  static const Color errorSnackbarText = Colors.white; // Warna teks snackbar error

  // Success Snackbar
  static const Color successSnackbar = Colors.green; // Warna snackbar sukses
  static const Color successSnackbarText = Colors.white;
}

