import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController emailController = TextEditingController();

  // Fungsi future untuk mengirim email reset password dengan Firebase Auth
  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      Get.snackbar(
        'Notice',
        "we've sent you a link to reset your password if your email exists",
        backgroundColor: AppColors.successSnackbar,
        colorText: AppColors.successSnackbarText,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryColor),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Reset Password',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Enter your email and we will send a link to reset your password to your gmail.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textFieldBorder,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),
              Image.asset('assets/reset_pass.png', height: 150, width: 150),
              SizedBox(height: 40),

              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: AppColors.textFieldBorder,
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: AppColors.textFieldBorder),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  filled: true,
                  fillColor: AppColors.lightgrey,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: AppColors.textFieldBackground,
                      width: 1,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),

              // Reset Password Button
              ElevatedButton(
                onPressed: () {
                  passwordReset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
