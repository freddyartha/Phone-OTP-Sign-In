import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  var auth = FirebaseAuth.instance;
  void signOutOnTap() {
    auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
