import 'package:get/get.dart';

class WebViewControllerX extends GetxController {
  var url = "".obs;

  // FUNCTION: Update URL untuk WebView
  void loadUrl(String newUrl) {
    url.value = newUrl;
    update();
  }
}
