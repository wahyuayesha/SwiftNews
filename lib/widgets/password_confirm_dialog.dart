import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';

Future<String?> showPasswordDialog() {
  final TextEditingController passwordController = TextEditingController();

  return Get.dialog<String>(
    AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          
          // Password TextField
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Confirm password',
              hintStyle: TextStyle(color: AppColors.textFieldBorder),
              prefixIcon: Icon(Icons.lock, color: AppColors.textFieldBorder),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              filled: true,
              fillColor: AppColors.textFieldBackground,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(
                  color: AppColors.textFieldBackground,
                  width: 1,
                ),
              ),
            ),
          ),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: null), // batal
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final password = passwordController.text.trim();
            Get.back(result: password); 
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}