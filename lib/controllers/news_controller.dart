import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constants/config.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/models/news.dart';

// Controller untuk halaman berita setiap ketegori
class NewsController extends GetxController {
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  var articles = <News>[].obs; // Menyimpan data berita yang didapat dari API
  var selectedCategory = 'business'.obs; // Menampung kategori berita yang dipilih
  var isLoading = false.obs; // Menandakan status loading

  // Kategori berita yang akan ditampilkan
  final categories =
      <String>[
        'business',
        'entertainment',
        'health',
        'science',
        'sports',
        'technology',
      ].obs;

  // Menjalankan diawal ketika controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  // FUNCTION: Mengambil berita dari API berdasarkan kategori yang dipilih
  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
          '$baseUrl?country=us&category=${selectedCategory.value}&apiKey=${AppConfig().apiKey}',
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

  // FUNCTION: Untuk mengupdate kategori berita yang dipilih
  void updateCategory(String category) {
    selectedCategory.value = category;
    fetchNews();
    update();
  }

  // FUNCTION: Untuk mengecek apakah kategori yang dipilih sama dengan kategori yang diberikan
  bool isSelectedCategory(String category) {
    return selectedCategory.value == category;
  }
}
