import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/pages/auth/sign_in.dart';
import 'package:newsapp/pages/auth/sign_up.dart';
import 'package:newsapp/widgets/password_dialog.dart';

class AuthController extends GetxController {
  final SignUpController signUpController = Get.put(SignUpController());
  final SignInController signInController = Get.put(SignInController());
  final UserController userController = Get.find();
  final BookmarkController bookmarkController = Get.find();

  RxBool isloading = false.obs; // Menandakan apakah sedang loading


  // FUNGSI UNTUK (SIGN UP)
  Future signUp() async {
    isloading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signUpController.emailController.text.trim(),
            password: signUpController.passwordController.text.trim(),
          );

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


  // FUNGSI UNTUK (SIGN IN)
  Future signIn() async {
    isloading.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInController.emailController.text.trim(),
        password: signInController.passwordController.text.trim(),
      );
      await userController.fetchUserData();
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


  // FUNGSI UNTUK (LOGOUT)
  Future<void> logout() async {
    // Menghapus data user dari controller
    userController.userModel.value = null;
    await FirebaseAuth.instance.signOut();
    // Menghapus data bookmark
    bookmarkController.clearBookmarks();
  }


  // FUNGSI UNTUK (HAPUS) AKUN
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
      await bookmarkController.deleteAllUserBookmarks();

      // hapus akun di firebase auth
      await user.delete();

      Get.snackbar('Success', 'Account deleted permanently.');
      Get.offAll(Main());
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

