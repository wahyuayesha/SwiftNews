import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/app_routes.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/pages/auth/sign_in.dart';
import 'package:newsapp/pages/auth/sign_up.dart';
import 'package:newsapp/widgets/password_confirm_dialog.dart';

class AuthController extends GetxController {
  final SignUpController signUpController = Get.put(SignUpController());
  final SignInController signInController = Get.put(SignInController());
  final UserController userController = Get.find();
  final BookmarkController bookmarkController = Get.find();

  RxBool isloading = false.obs; // Menandakan apakah sedang loading
  

  // FUNCTION: Untuk (SIGN UP)
  Future signUp() async {
    isloading.value = true;
    try {
      // Membuat user baru dengan email dan password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signUpController.emailController.text.trim(),
            password: signUpController.passwordController.text.trim(),
          );

      // Setelah berhasil sign up, simpan data user ke Firestore (tabel users)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'username': signUpController.usernameController.text.trim(),
            'email': signUpController.emailController.text.trim(),
            'createdAt': DateTime.now().toString(),
          });

      // Menghapus data dari textfield setelah sign in
      signUpController.usernameController.clear();
      signUpController.emailController.clear();
      signUpController.passwordController.clear();
      // Mengambil data user 
      await userController.fetchUserData();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message ?? 'An error occurred',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    } finally {
      isloading.value = false;
    }
  }


  // FUNCTION: Untuk (SIGN IN)
  Future signIn() async {
    isloading.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInController.emailController.text.trim(),
        password: signInController.passwordController.text.trim(),
      );
      // Setelah berhasil login, ambil data user
      await userController.fetchUserData();
      // Ambil data bookmark setelah login
      await bookmarkController.fetchBookmarkedNews();
      // Menghapus data dari textfield setelah login
      signInController.emailController.clear();
      signInController.passwordController.clear();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message ?? 'An error occurred',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    } finally {
      isloading.value = false;
    }
  }


  // FUNCTION: Untuk (LOG OUT)
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Menghapus data user dari controller
      userController.userModel.value = null;
      // Menghapus data bookmark
      bookmarkController.clearControllerBookmarks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Log out failed: ${e.toString()}',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }

  // FUNCTION: Untuk (DELETE ACCOUNT)
  Future<void> deleteUserAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar(
        'Error',
        'User not found.',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
      return;
    }

    final password = await showPasswordDialog();

    if (password == null || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Password must be filled to delete account.',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
      return;
    }

    try {
      // reauthenticate user dengan credential email + password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // hapus data di firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // hapus semua bookmark user 
      await bookmarkController.deleteFirestoreBookmarks();

      // hapus akun di firebase auth
      await user.delete();

      Get.snackbar('Success', 'Account deleted permanently.');
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error occured: $e',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }
}

