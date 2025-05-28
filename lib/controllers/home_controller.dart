import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constants/config.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/models/news.dart';

class HomeController extends GetxController {
  final String baseUrl = 'https://newsapi.org/v2';

  var topHeadlines = <News>[].obs; // Variabel untuk berita utama
  var popularNews = <News>[].obs; // Variabel untuk berita populer
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews(type: 'top-headlines'); // Ambil berita top
    fetchNews(type: 'everything', sortBy: 'popularity'); // Ambil berita populer
  } 

  // FUNCTION: Mengambil berita dari API
  Future<void> fetchNews({
    required String type,
    String? sortBy,
  }) async {
    try {
      isLoading.value = true;
      Uri url;

      if (type == 'top-headlines') {
        url = Uri.parse("$baseUrl/top-headlines?country=us&apiKey=${AppConfig().apiKey}");
      } else {
        url = Uri.parse(
          "$baseUrl/everything?q=trending&sortBy=$sortBy&apiKey=${AppConfig().apiKey}",
        );
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["articles"] != null) {
          var articles = List<News>.from(
            data["articles"].map<News>((item) => News.fromJson(item)).toList(),
          );

          if (type == 'top-headlines') {
            topHeadlines.value = articles;
          } else {
            popularNews.value = articles;
          }
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch news',
          backgroundColor: AppColors.errorSnackbar,
          colorText: AppColors.errorSnackbarText,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error occured: ${e.toString()}',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
