import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/model/api_data_class.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';

class EditOrdersController extends GetxController {
  bool isSlider = true;
  bool isLoading = false;
  dynamic editArguments;

  orderDataUpdate() async {
    try {
      isLoading = true;
      update();
      var request = {
        "orderDetails": editArguments,
      };
      APIDataClass response = await apis.call(
        apiMethods.orderDataUpdate,
        request,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        Get.rawSnackbar(
          title: null,
          messageText: Text(
            response.message!,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          borderRadius: 0,
          margin: const EdgeInsets.all(0),
        );
      } else {
        Get.rawSnackbar(
          title: null,
          messageText: Text(
            response.message!,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber,
          snackPosition: SnackPosition.TOP,
          borderRadius: 0,
          margin: const EdgeInsets.all(0),
        );
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    }
  }
}
