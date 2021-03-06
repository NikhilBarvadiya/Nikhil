// ignore_for_file: empty_catches
import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/core/utilities/storage_utils.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSlider = false;
  bool isVisible = false;
  bool isRemember = false;

  void updateStatus() {
    isVisible = !isVisible;
    update();
  }

  dynamic logonData;

  void onLoginButton(String email, String password) async {
    try {
      var resData = await apis.call(
          apiMethods.login,
          {
            "email": email,
            "password": password,
            "type": "order_manager",
          },
          ApiType.post);
      logonData = resData.data;
      if (resData.isSuccess == true && resData.data != 0) {
        await writeStorage(Session.userData, resData.data);
        await writeStorage(Session.authToken, resData.data['token']);
        Get.toNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          "Error",
          "Please try again ?",
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        throw Exception("Failed to load users");
      }
    } catch (e) {}
  }

  onRemember() {
    isRemember = !isRemember;
    update();
  }
}
