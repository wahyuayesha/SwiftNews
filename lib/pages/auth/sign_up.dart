import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/widgets/loading_button.dart';
import 'package:newsapp/widgets/welcome_dialog.dart';

class SignUpController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class SignUpPage extends StatelessWidget {
  final VoidCallback showSignInPage;
  SignUpPage({super.key, required this.showSignInPage});

  final SignUpController controller = Get.put(SignUpController());
  final UserController userController = Get.put(UserController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textFieldBorder,
                        ),
                      ),
                      SizedBox(height: 70),
                      // Username
                      TextField(
                        controller: controller.usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.textFieldBorder,
                          ),
                          hintText: 'Create username',
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

                      SizedBox(height: 10),

                      // Email
                      TextField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: AppColors.textFieldBorder,
                          ),
                          hintText: 'Email',
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

                      SizedBox(height: 10),

                      // Password
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

                      SizedBox(height: 40),

                      // Sign Up Button
                      LoadingButton(
                        isLoading: authController.isloading,
                        onPressed: () async {
                          await authController.signUp();
                          if (userController.user.value != null) {
                            Get.dialog(WelcomeDialog());
                          }
                        },
                        label: 'Sign Up',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textFieldBorder,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showSignInPage();
                    },
                    child: Text('Sign In'),
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
