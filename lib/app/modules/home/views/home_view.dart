import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../mahas/components/mahas_themes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MahasThemes.borderRadius),
          ),
          child: ElevatedButton(
            onPressed: () {
              controller.signOutOnTap();
            },
            child: const Text("SIGN OUT"),
          ),
        ),
      ),
    );
  }
}
