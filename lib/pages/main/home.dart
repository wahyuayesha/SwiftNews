import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:newsapp/constants/app_routes.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/functions/format_waktu.dart';
import 'package:newsapp/widgets/appbar.dart';
import 'package:newsapp/widgets/image_network_shimmer.dart';
import 'package:newsapp/widgets/newsTile.dart';
import 'package:newsapp/controllers/home_controller.dart';
import 'package:newsapp/controllers/webView_controller.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/widgets/shimmer_news.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController homeController = Get.find();
  final WebViewControllerX webViewController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: MyAppBar(),
        surfaceTintColor: AppColors.background,
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (homeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (homeController.topHeadlines.isEmpty) {
                  return Center(
                    child: Image.asset('assets/nodata.png', scale: 2),
                  );
                }
                return SizedBox(
                  height: 200, 
                  child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final topnews = homeController.topHeadlines[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: _buildBeritaUtama(context, topnews),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Text(
                  'Popular News',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (homeController.isLoading.value) {
                return ShimmerLoading();
              }
              if (homeController.popularNews.isEmpty) {
                return Center(
                  child: Image.asset('assets/nodata.png', scale: 2),
                );
              }
              return ListView.builder(
                itemCount: homeController.popularNews.length,
                itemBuilder: (context, index) {
                  final popnews = homeController.popularNews[index];
                  return NewsItem(news: popnews);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan berita utama
  Widget _buildBeritaUtama(BuildContext context, News news) {
    return GestureDetector(
      onTap: () {
        webViewController.loadUrl(news.url);
        Get.toNamed(AppRoutes.newsContent);
      },
      child: Stack(
        children: [
          // Gambar
          Container(
            height: 200,
            width: 320,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.hardEdge,
            child:
                news.imageUrl != ''
                    ? ImageNetworkShimmer(imageUrl: news.imageUrl)
                    : Image.asset('assets/noImage.png', fit: BoxFit.fill),
          ),
          // Meredupkan gambar
          Container(
            height: 200,
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(83, 0, 0, 0),
            ),
          ),
          // Teks sumber
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              news.source,
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              formatWaktu(news.publishedAt),
              style: const TextStyle(color: Color.fromARGB(172, 255, 255, 255)),
            ),
          ),
          // Teks judul dan animasi
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // Agar tidak melebihi lebar yang diperlukan
              children: [
                Lottie.asset(
                  'assets/animation/popular.json',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
