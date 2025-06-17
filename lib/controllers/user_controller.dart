import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/app_routes.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/models/user.dart';
import 'package:newsapp/services/fire_services.dart';

class UserController extends GetxController {
  var user = Rxn<User>(); // dari firebase auth
  var userModel = Rxn<UserModel>(); // dari firestore

  RxBool isLoading = false.obs;
  final service = FireServices();

  // Ambil data user dari Firebase Auth di awal controller diinisialisasi
  @override
  void onInit() {
    super.onInit();

    user.value = FirebaseAuth.instance.currentUser;
    if (user.value != null) {
      fetchUserData();
    }

    // Dengarkan perubahan status login user
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      user.value = firebaseUser;
      if (firebaseUser != null) {
        await fetchUserData();
      } else {
        userModel.value = null;
      }
    });
  }

  // FUNCTION: untuk mengambil data user dari Firestore
  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final data = await FireServices().fetchUserData(
        uid,
      ); // panggil fungsi dari FireServices
      if (data != null) {
        userModel.value = data;
      } else {
        userModel.value = null;
        Get.snackbar(
          'Error',
          'Failed to fetch user data',
          backgroundColor: AppColors.errorSnackbar,
          colorText: AppColors.errorSnackbarText,
        );
      }
    } else {
      userModel.value = null;
    }
  }

  /// FUNCTION: untuk memperbarui data user
  Future<void> updateUserData({
    required String currentPassword,
    required String newUsername,
    required String newProfilePictureUrl,
    required String newPassword,
  }) async {
    isLoading.value = true;

    final error = await service.updateUserData(
      currentPassword: currentPassword,
      newUsername: newUsername,
      newProfilePictureUrl: newProfilePictureUrl,
      newPassword: newPassword,
    );

    isLoading.value = false;

    if (error == null) {
      await fetchUserData();
      Get.snackbar(
        'Success',
        'Your data has been updated successfully!',
        backgroundColor: AppColors.successSnackbar,
        colorText: AppColors.successSnackbarText,
      );
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.snackbar(
        'Error',
        error,
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }

  // FUNCTION: report bug
  Future<void> reportBug(String bugReport) async {
    final error = await service.reportBug(bugReport, 
      userModel.value?.email ?? 'No email',
      userModel.value?.username ?? 'No username',
    );
    if (error == null) {
      Get.snackbar(
        'Success',
        'Bug report submitted, thank you!',
        backgroundColor: AppColors.successSnackbar,
        colorText: AppColors.successSnackbarText,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to report bug: $error',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }
}
