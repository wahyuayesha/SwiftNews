import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/widgets/alert.dart';
import 'package:newsapp/widgets/clip.dart';

class EditProfileController extends GetxController {
  var obscurePassword = true.obs;
  var obscureNewPassword = true.obs;

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleObscureNewPassword() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }
}

// ignore: must_be_immutable
class EditAkun extends StatelessWidget {
  EditAkun({super.key});

  final EditProfileController editController = Get.put(EditProfileController());
  final UserController userController = Get.put(UserController());
  final AuthController authController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  // URL gambar profil yang dipilih sementara
  final RxString profilePictureUrl = ''.obs;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary08,
        foregroundColor: AppColors.background,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: HeaderClipPath(),
              child: Container(
                height: height * 0.13,
                width: width,
                color: AppColors.primary08,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Obx(() {
                              final user = userController.userModel.value;
                              final selectedUrl = profilePictureUrl.value;

                              return CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    selectedUrl.isNotEmpty
                                        ? AssetImage(selectedUrl)
                                        : user != null &&
                                            user.profilePictureUrl.isNotEmpty
                                        ? AssetImage(user.profilePictureUrl)
                                        : AssetImage('assets/profilejpg'),
                              );
                            }),

                            IconButton.filled(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 170,
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    3, // Jumlah kolom
                                                crossAxisSpacing:
                                                    10, // Jarak antar kolom
                                                mainAxisSpacing:
                                                    10, // Jarak antar baris
                                              ),
                                          itemCount: 6,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                // Lakukan sesuatu saat gambar dipilih
                                                profilePictureUrl.value =
                                                    'assets/profile/profile${index + 1}.jpg';
                                                Navigator.pop(context);
                                              },
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundImage: AssetImage(
                                                  'assets/profile/profile${index + 1}.jpg',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          final user = userController.userModel.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                user != null && user.username.isNotEmpty
                                    ? user.username
                                    : 'Loading...',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user != null && user.email.isNotEmpty
                                    ? user.email
                                    : 'Loading...',
                                style: const TextStyle(color: Colors.black45),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 40),
                        myTextField(
                          'New Username',
                          Icon(Icons.person, color: AppColors.textFieldBorder),
                          usernameController,
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => myTextField(
                            'New Password',
                            Icon(Icons.lock, color: AppColors.textFieldBorder),
                            newPasswordController,
                            obscureText:
                                editController.obscureNewPassword.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                editController.obscureNewPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textFieldBorder,
                              ),
                              onPressed:
                                  () =>
                                      editController.toggleObscureNewPassword(),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Divider(
                          color: AppColors.textFieldBackground,
                          thickness: 1,
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => myTextField(
                            'Current Password',
                            Icon(Icons.lock, color: AppColors.textFieldBorder),
                            currentPasswordController,
                            obscureText: editController.obscurePassword.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                editController.obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textFieldBorder,
                              ),
                              onPressed:
                                  () => editController.toggleObscurePassword(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  TextButton(
                    onPressed: () {
                      alert(
                        'Save Changes',
                        'Are you sure you want to save changes?',
                        () async {
                          await userController.updateUserData(
                            newUsername: usernameController.text.trim(),
                            currentPassword:
                                currentPasswordController.text.trim(),
                            newPassword: newPasswordController.text.trim(),
                            newProfilePictureUrl:
                                profilePictureUrl.value.trim(),
                          );
                        },
                      );
                    },
                    child:
                        authController.isloading.value
                            ? CircularProgressIndicator(
                              color: AppColors.primary,
                            )
                            : Text(
                              'Save Changes',
                              style: TextStyle(color: AppColors.primary),
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget textfield
  Widget myTextField(
    String hint,
    Icon icon,
    TextEditingController controller, {
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textFieldBorder),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
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
    );
  }
}
