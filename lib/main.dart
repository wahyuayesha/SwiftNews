import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';
import 'package:newsapp/controllers/home_controller.dart';
import 'package:newsapp/controllers/news_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/controllers/webView_controller.dart';
import 'package:newsapp/pages/main/akun.dart';
import 'package:newsapp/pages/auth/auth_page.dart';
import 'package:newsapp/pages/main/berita.dart';
import 'package:newsapp/pages/main/bookmarked.dart';
import 'package:newsapp/pages/main/home.dart';
import 'package:newsapp/pages/main/search.dart';
import 'package:newsapp/pages/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Controller utama & global
  Get.put(UserController());  
  Get.put(HomeController());  
  Get.put(BookmarkController()); 
  Get.put(AuthController());

  // Controller halaman/fungsi
  Get.put(NewsController());
  Get.put(SearchController());
  
  // Controller tambahan
  Get.put(WebViewControllerX());

  // Pengecekan untuk fetch bookmark setelah login
  if (FirebaseAuth.instance.currentUser != null) {
  final userController = Get.find<UserController>();

  // Tunggu hingga userModel terisi (misalnya dari Firestore)
  await userController.fetchUserData(); // <- pastikan fungsi ini ada dan mengisi userModel
  await Get.find<BookmarkController>().fetchBookmarkedNews();
}
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: SplashScreen()), // Default halaman utama
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
      ),
    );
  }
}

// Dasar dari aplikasi
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();

    // Menggunakan Obx untuk mendeteksi perubahan pada user
    // Jika user sudah login, tampilkan MainPage, jika belum tampilkan AuthPage
    return Obx(() {
      if (user.user.value != null) {
        return MainPage();
      } else {
        return AuthPage();
      }
    });
  }
}

// Halaman utama aplikasi
class MainPage extends StatelessWidget {
  final RxInt indexHalaman = 2.obs;

  // Halaman yang akan ditampilkan
  final List<Widget> halaman = [
    Search(), // Halaman pencarian
    BeritaScreen(), // Berita per kategori
    HomePage(), // Beranda
    BookmarkView(), // Halaman pencarian
    MyAccount(), // Akun
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: halaman[indexHalaman.value], // Menampilkan halaman sesuai index
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: AppColors.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GNav(
                selectedIndex:
                    indexHalaman.value, // Menyesuaikan dengan tab yang aktif
                onTabChange: (index) {
                  indexHalaman.value =
                      index; // Mengubah halaman sesuai tab yang ditekan
                },
                backgroundColor: AppColors.primary,
                gap: 5,
                color: Color.fromRGBO(214, 75, 33, 1),
                activeColor: Colors.white,
                padding: EdgeInsets.all(16),
                tabs: const [
                  GButton(icon: Icons.search, text: 'Search'),
                  GButton(icon: Icons.newspaper, text: 'News'),
                  GButton(icon: Icons.home_rounded, text: 'Home'),
                  GButton(icon: Icons.bookmark_rounded, text: 'Saved'),
                  GButton(icon: Icons.person_rounded, text: 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
