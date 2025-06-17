import 'package:get/get.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/pages/auth/forgot_pass.dart';
import 'package:newsapp/pages/edit_akun.dart';
import 'package:newsapp/pages/news_content.dart';

class AppRoutes {
  static const main = '/main';
  static const home = '/home';
  static const akun = '/akun';
  static const editAkun = '/edit_akun';
  static const kategori = '/kategori';
  static const bookmark = '/bookmark';
  static const search = '/search';
  static const newsContent = '/news_content';
  static const forgotPassword = '/forgot_password';

  static final List<GetPage> routes = [
    GetPage(
      name: main, 
      page: () => Main(), 
      transition: Transition.fade
    ),
    GetPage(
      name: editAkun,
      page: () => EditAkun(),
      transition: Transition.fade,
    ),
    GetPage(
      name: newsContent,
      page: () => WebViewPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPasswordPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
