import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/widgets/alert.dart';
import 'package:newsapp/widgets/appbar.dart';
import 'package:newsapp/widgets/newsTile.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';

class BookmarkView extends StatelessWidget {
  BookmarkView({super.key});
  final BookmarkController bookmarkController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: MyAppBar(),
        surfaceTintColor: AppColors.background,
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        return bookmarkController.bookmarked_news.isEmpty
            ? Center(child: Image.asset('assets/nodata.png', scale: 2))
            : ListView.builder(
              itemCount: bookmarkController.bookmarked_news.length,
              itemBuilder: (context, index) {
                return NewsItem(
                  news: bookmarkController.bookmarked_news[index],
                );
              },
            );
      }),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        foregroundColor: AppColors.background,
        backgroundColor: AppColors.primary,
        onPressed: () {
          alert(
            'Delete All Bookmarks',
            'Are you sure you want to delete all bookmarks?',
            () {
              if (bookmarkController.bookmarked_news.isEmpty) {
                Get.snackbar(
                  'Error',
                  'No bookmarks to delete',
                  backgroundColor: AppColors.errorSnackbar,
                  colorText: AppColors.errorSnackbarText,
                );
                return;
              }
              bookmarkController.deleteFirestoreBookmarks();
              bookmarkController.clearControllerBookmarks();
              Get.back();
            },
          );
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
