import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constants/config.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/models/news.dart';

// Controller untuk halaman pencarian berita (mengambil data berita berdasarkan keyword)
class SearchKeywordController extends GetxController {
  final String baseUrl = 'https://newsapi.org/v2';

  var articles = <News>[].obs; // Menampung data berita yang didapat dari API
  var keyword = ''.obs; // Mnampung keyword pencarian yang diketik user
  var isLoading = false.obs; // Menandakan status loading

  // Menjalankan diawal ketika controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
    fetchKeywordNews();
  }

  // FUNCTION: Mengambil berita dari API berdasarkan keyword yang diinputkan user
  Future<void> fetchKeywordNews() async {
    if (keyword.value.isEmpty) {
      return;
    }

    try {
      isLoading.value = true; 
      final response = await http.get(
        Uri.parse(
          "$baseUrl/everything?q=${Uri.encodeQueryComponent(keyword.value)}&sortBy=relevancy&apiKey=${AppConfig().apiKey}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); 
        if (data["articles"] != null) {
          articles.value = List<News>.from(
            data["articles"].map<News>((item) => News.fromJson(item)).toList(),
          );
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

  // FUNCTION: Untuk mencari berita berdasarkan keyword yang diinputkan user
  void searchNews(String newKeyword) {
    keyword.value = newKeyword; // Mengubah keyword yang dicari
    fetchKeywordNews();
  }
}
