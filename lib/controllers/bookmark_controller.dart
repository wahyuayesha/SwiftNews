import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/services/fire_services.dart';

class BookmarkController extends GetxController {
  final UserController userController = Get.find<UserController>();
  RxList<News> bookmarked_news = <News>[].obs; // Menyimpan berita yang sudah di bookmark pada user saat ini
  FireServices service = FireServices();

  // FUNCTION: Mengecek apakah berita sudah di bookmark
  bool isBookmarked(News news) {
    return bookmarked_news.any((item) => item.title == news.title);
  }

  // FUNCTION: Menambahkan berita ke bookmark (jika belum ada)
  Future<void> addBookmark(News news) async {
    if (!isBookmarked(news)) {
      final error = await service.addBookmark(news, userController.userModel.value?.email ?? '');
      if (error == null) {
        // Tambahkan ke UI secara realtime
        bookmarked_news.add(news);
      } else {
        Get.snackbar(
          'Error',
          error,
          backgroundColor: AppColors.errorSnackbar,
          colorText: AppColors.errorSnackbarText,
        );
      }
    }
  }

  // FUNCTION: Menghapus berita dari bookmark
  Future<void> removeBookmark(News news) async {
    final error = await service.removeBookmark(news, userController.userModel.value?.email ?? '');
    if (error == null) {
      // Hapus dari UI
      bookmarked_news.removeWhere((item) => item.url == news.url);
    } else {
      Get.snackbar(
        'Error',
        error,
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }

  // FUNCTION: Fetch semua bookmark user dari Firestore
  Future<void> fetchBookmarkedNews() async {
    final error = await service.fetchBookmarkedNews(userController.userModel.value?.email ?? '', );
    if (error != null) {
      Get.snackbar(
        'Error',
        error,
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }
  
  // FUNCTION: Menghapus semua bookmark user di Firestore
  Future<void> deleteFirestoreBookmarks() async {
    final email = userController.userModel.value?.email;

    if (email != null) {
      final error = await service.deleteFirestoreBookmarks(email);
      if (error != null) {
        Get.snackbar(
          'Error',
          error,
          backgroundColor: AppColors.errorSnackbar,
          colorText: AppColors.errorSnackbarText,
        );
      }
    }
  }

  // FUNCTION: Menghapus semua bookmark dari controller
  void clearControllerBookmarks() {
    bookmarked_news.clear();
  }
}
