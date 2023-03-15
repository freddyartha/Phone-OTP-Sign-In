import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

import 'app/mahas/components/mahas_themes.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      title: "PHONE AUTH",
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      theme: MahasThemes.light,
      initialRoute: AppPages.INITIAL,
      builder: EasyLoading.init(),
    ),
  );
}
