import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/functions/format_waktu.dart';
import 'package:newsapp/pages/edit_akun.dart';
import 'package:newsapp/widgets/alert.dart';
import 'package:newsapp/widgets/appbar.dart';
// import 'package:newsapp/pages/edit_akun.dart';

// ignore: must_be_immutable
class MyAccount extends StatelessWidget {
  UserController userController = Get.find();
  AuthController authController = Get.find();

  MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyAppBar(), backgroundColor: AppColors.background),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Profile
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      final user = userController.userModel.value;
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            user != null && user.profilePictureUrl.isNotEmpty
                                ? AssetImage(user.profilePictureUrl)
                                : AssetImage('assets/profile.jpeg'),
                      );
                    }),

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

                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(EditAkun(), transition: Transition.fade);
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Tile-tile pengaturan
              Column(
                children: [
                  tilePengaturan(
                    context,
                    const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.grey,
                    ),
                    'Account',
                    account(context),
                    const Icon(Icons.navigate_next_rounded),
                  ),
                  tilePengaturan(
                    context,
                    const Icon(Icons.help_outline_outlined, color: Colors.grey),
                    'About',
                    about(context),
                    const Icon(Icons.navigate_next_rounded),
                  ),
                  tilePengaturan(
                    context,
                    const Icon(Icons.bug_report_outlined, color: Colors.grey),
                    'Report Bug',
                    reportBug(context),
                    const Icon(Icons.navigate_next_rounded),
                  ),
                  // tilePengaturan(
                  //   context,
                  //   const Icon(Icons.light_mode_outlined, color: Colors.grey),
                  //   'Theme',
                  //   reportBug(context),
                  //   Switch(
                  //     value: false,
                  //     onChanged: (value) {
                  //       value = !value;
                  //     },
                  //     inactiveTrackColor: AppColors.primary),
                  // ),
                ],
              ),
              const SizedBox(height: 20),

              // Button Sign Out
              TextButton(
                onPressed: () {
                  authController.logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.logout_outlined, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(
                      'Sign out',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk tile pengaturan
  Widget tilePengaturan(
    BuildContext context,
    Icon icon,
    String teks,
    Widget route,
    Widget? trailing,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(13),
      ),
      child: ListTile(
        leading: icon,
        title: Text(teks),
        trailing: trailing,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: route);
            },
          );
        },
      ),
    );
  }

  // Widget untuk user report bug
  Widget reportBug(context) {
    final TextEditingController reportController = TextEditingController();
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Text(
            'Report Bug',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: reportController,
            decoration: InputDecoration(
              hintText: 'Enter bug description',
              hintStyle: TextStyle(color: AppColors.textFieldBorder),
              prefixIcon: Icon(Icons.search, color: AppColors.textFieldBorder),
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
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              // Kirim laporan bug
              await userController.reportBug(reportController.text);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
            ),
            child: const Text('Send Report'),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan informasi akun
  Widget account(context) {
    final user = userController.userModel.value;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Text(
            'Account',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Username: ${user.username}',
                style: TextStyle(color: AppColors.textFieldBorder),
              ),
              Text(
                'Email: ${user.email}',
                style: TextStyle(color: AppColors.textFieldBorder),
              ),
              Text(
                'Created At: ${formatWaktu(user.createdAt)}',
                style: TextStyle(color: AppColors.textFieldBorder),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              alert(
                'Delete Account',
                'Are you sure you want to delete your current account?',
                () async {
                  await authController.deleteUserAccount();
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: AppColors.background,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan informasi tentang aplikasi
  Widget about(context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Text(
            'About SwiftNews',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'SwiftNews is a news application that provides the latest news articles from various sources. It allows users to bookmark articles, search for specific topics, and customize their news feed based on their interests.',
            style: TextStyle(color: AppColors.textFieldBorder),
          ),
          SizedBox(height: 10),
          Text(
            'SwiftNews sourced from NewsAPI.org an API that provides access to news articles from various sources around the world.',
            style: TextStyle(color: AppColors.textFieldBorder),
          ),
        ],
      ),
    );
  }
}
