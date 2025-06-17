import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/app_routes.dart';
import 'package:newsapp/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), ()=> Get.offNamed(AppRoutes.main));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(child: Image.asset('assets/icon.png', scale:3.5,))
    );
  }
}
