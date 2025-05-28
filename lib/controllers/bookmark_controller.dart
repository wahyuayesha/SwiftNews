import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/models/news.dart';

class BookmarkController extends GetxController {
  final UserController userController = Get.find<UserController>();
  RxList<News> bookmarked_news =
      <News>[]
          .obs; // Menyimpan berita yang sudah di bookmark pada user saat ini

  // FUNCTION: Mengecek apakah berita sudah di bookmark
  bool isBookmarked(News news) {
    return bookmarked_news.any((item) => item.title == news.title);
  }

  // Menambahkan berita ke bookmark (jika belum ada)
  Future<void> addBookmark(News news) async {
    if (!isBookmarked(news)) {
      try {
        await FirebaseFirestore.instance.collection('bookmarked').add({
          'title': news.title,
          'url': news.url,
          'urlToImage': news.imageUrl,
          'source': news.source,
          'email': userController.userModel.value?.email,
          'publishedAt': news.publishedAt,
        });

        // Tambahkan ke UI secara realtime
        bookmarked_news.add(news);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to add bookmark: $e',
          backgroundColor: AppColors.errorSnackbar,
          colorText: AppColors.errorSnackbarText,
        );
      }
    }
  }

  // FUNCTION: Menghapus berita dari bookmark
  Future<void> removeBookmark(News news) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('bookmarked')
              .where('url', isEqualTo: news.url)
              .where('email', isEqualTo: userController.userModel.value?.email)
              .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Hapus dari UI
      bookmarked_news.removeWhere((item) => item.url == news.url);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to deleting bookmark: $e',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }

  // FUNCTION: Fetch semua bookmark user dari Firestore
  Future<void> fetchBookmarkedNews() async {
    try {
      final email = userController.userModel.value?.email;
      final snapshot =
          await FirebaseFirestore.instance
              .collection('bookmarked')
              .where('email', isEqualTo: email)
              .get();

      bookmarked_news.clear();
      for (var doc in snapshot.docs) {
        bookmarked_news.add(
          News(
            title: doc['title'] ?? 'No Title',
            url: doc['url'] ?? '',
            imageUrl: doc['urlToImage'] ?? '',
            source: doc['source'] ?? 'No Source',
            publishedAt: doc['publishedAt'] ?? ''
          ),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data bookmark: $e');
    }
  }

  // FUNCTION: Menghapus semua bookmark user di Firestore
  Future<void> deleteFirestoreBookmarks() async {
    try {
      final email = userController.userModel.value?.email;

      if (email != null) {
        // Cari dan hapus data bookmark berdasarkan email
        final snapshot =
            await FirebaseFirestore.instance
                .collection('bookmarked')
                .where('email', isEqualTo: email)
                .get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to deleting bookmarks: $e',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    }
  }

  // FUNCTION: Menghapus semua bookmark dari controller
  void clearControllerBookmarks() {
    bookmarked_news.clear();
  }
}
