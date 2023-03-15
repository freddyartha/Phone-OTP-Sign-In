import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:phone_sign_in/app/mahas/mahas_colors.dart';
import 'package:phone_sign_in/app/routes/app_pages.dart';

import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/services/helper.dart';

class LoginController extends GetxController {
  RxString phoneCon = "".obs;
  RxString verId = ''.obs;
  RxString verify = ''.obs;
  RxInt count = 0.obs;
  var auth = FirebaseAuth.instance;

  Future<bool> bottomSheetBack() async {
    Helper.dialogQuestionWithAction(
      message: "Are you sure want to go back?",
      confirmAction: () async {
        Get.back(closeOverlays: true);
      },
    );
    return true;
  }

  void countDown() {
    count.value = 60;
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (count.value > 0) {
          count.value--;
        } else {
          timer.cancel();
        }
      },
    );
  }

  void signInOnTap() async {
    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }
    EasyLoading.show();
    if (phoneCon.value == "") {
      Get.defaultDialog(title: "field is required");
    } else {
      await verifyPhone(phoneCon.value);
      EasyLoading.dismiss();
      countDown();
      await showMaterialModalBottomSheet(
        expand: true,
        isDismissible: false,
        context: Get.context!,
        builder: (context) => WillPopScope(
          onWillPop: () => bottomSheetBack(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("OTP PAGE"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Kode OTP dikirim ke : ${phoneCon.value}",
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(MahasThemes.borderRadius),
                      ),
                      child: TextButton(
                          onPressed: () {
                            Get.back(closeOverlays: true);
                          },
                          child: Text(
                            "Ganti Nomor HP",
                            style: MahasThemes.link,
                          )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: MahasColors.primary,
                      focusedBorderColor: MahasColors.primary,
                      textStyle: MahasThemes.h1,
                      showFieldAsBox: false,
                      borderWidth: 4.0,
                      onSubmit: (String verificationCode) {
                        verify.value = verificationCode;
                        otpOnTap();
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(MahasThemes.borderRadius),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (count.value == 0) {
                            resendOTPOnTap();
                          }
                        },
                        child: Obx(
                          () => count.value == 0
                              ? Text(
                                  "Kirim Ulang OTP",
                                  style: MahasThemes.link,
                                )
                              : Text(
                                  "Kirim Ulang OTP (${count.value}) detik",
                                  style: MahasThemes.link,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    EasyLoading.dismiss();
  }

  void otpOnTap() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();
    await otpVerify(verify.value.toString());
    countDown();
    EasyLoading.dismiss();
  }

  void resendOTPOnTap() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();
    await verifyPhone(phoneCon.value);
    countDown();
    EasyLoading.dismiss();
  }

  //verifikasi no hp user untuk kirim OTP
  verifyPhone(String phone) async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 40),
      phoneNumber: phone,
      verificationCompleted: (AuthCredential authCredential) {
        if (auth.currentUser != null) {
          Helper.dialogSuccess("Anda sudah login!");
        }
      },
      verificationFailed: (authException) {
        if (authException.message!
            .contains((RegExp('expired', caseSensitive: false)))) {
          Helper.dialogWarning("Verifikasi recaptcha gagal!\nKode kadaluarsa");
        } else {
          Helper.dialogWarning(authException.message!);
        }
      },
      codeSent: (verificationId, forceResendingToken) {
        verId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String id) {
        verId.value = id;
      },
    );
  }

  //cek kode OTP untuk melanjutkan ke home
  otpVerify(String otp) async {
    try {
      UserCredential userCredential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verId.value, smsCode: otp));
      if (userCredential.user != null) {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Helper.dialogWarning("Kode OTP tidak sesuai!");
    }
  }
}
