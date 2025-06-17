import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/app_routes.dart';
import 'package:newsapp/widgets/loading_button.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class SignInPage extends StatelessWidget {
  final VoidCallback showSignUpPage;
  SignInPage({super.key, required this.showSignUpPage});

  final SignInController controller = Get.put(SignInController());
  final UserController userController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter your credential to continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldBorder,
                      ),
                    ),
                    SizedBox(height: 70),
                    TextField(
                      controller: controller.emailController,
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
                    SizedBox(height: 10),
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppColors.textFieldBorder,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.obscurePassword.toggle();
                            },
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.textFieldBorder,
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: AppColors.textFieldBorder,
                          ),
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
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.forgotPassword);
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    LoadingButton(
                      isLoading: authController.isloading,
                      label: 'Sign In',
                      onPressed: () async {
                        await authController.signIn();
                      },
                    ),

                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),

            // Bagian bawah tetap
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textFieldBorder,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showSignUpPage();
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
