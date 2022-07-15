import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/model/api_data_class.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';

class CodSettlementController extends GetxController {
  bool isLoading = false;
  dynamic codDetails;
  String text = "hello";

  @override
  void onInit() {
    vCodSettlementgetDetails();
    super.onInit();
  }

  vCodSettlementgetDetails() async {
    try {
      isLoading = true;
      update();
      APIDataClass response = await apis.call(
        apiMethods.vCodSettlementgetDetails,
        {},
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        codDetails = response.data;
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
      return codDetails;
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
