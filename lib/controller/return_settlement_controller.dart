import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/model/api_data_class.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:dio/dio.dart' as dioForm;

class ReturnSettlementController extends GetxController {
  String vendorSelectedOrder = "Return order";
  final txtDescription = TextEditingController();
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  File? imageFile;
  List selectedVendorId = [];
  List returnSettlement = [];
  String isReturnSettlement = "";
  String isReturnSettlementId = "";
  dynamic returnVendor;

  @override
  void onInit() {
    onReturnSettlementApiCalling();
    super.onInit();
  }

  List selectedOrder = [
    {
      "selectedOrder": "Pending Order",
      "isActive": true,
    },
    {
      "selectedOrder": "Complete Order",
      "isActive": false,
    },
  ];

  onChange(int i) {
    for (int a = 0; a < selectedOrder.length; a++) {
      if (a == i) {
        selectedOrder[a]["isActive"] = true;
        isReturnSettlement = "";
        isReturnSettlementId = "";
        vendorSelectedOrder = selectedOrder[a]["selectedOrder"];
      } else {
        selectedOrder[a]["isActive"] = false;
        selectedVendorId.clear();
      }
    }
    onReturnSettlementApiCalling();
    update();
  }

  onClear() {
    isReturnSettlement = "";
    isReturnSettlementId = "";
    selectedVendorId.clear();
    txtDescription.clear();
    controller.clear();
    returnSettlement.clear();
    update();
    onReturnSettlementApiCalling();
  }

  onReturnSettlementApiCalling() async {
    await fatchReturnSettlement();
    await fatchvendorReturnSettlement();
    update();
  }

  addToSelectedList(item) {
    if (item != null) {
      var index = selectedVendorId.indexOf(item);
      if (index == -1) {
        selectedVendorId.add(item);
      } else {
        selectedVendorId.remove(item);
      }
      _autoSelector();
    }
  }

  _autoSelector() {
    if (returnSettlement.isNotEmpty) {
      for (int i = 0; i < returnSettlement.length; i++) {
        int finder = 0;
        for (int j = 0; j < selectedVendorId.length; j++) {
          if (returnSettlement[i]['_id'] == selectedVendorId[j]['_id']) {
            returnSettlement[i]['selected'] = true;
            finder++;
          }
        }
        if (finder == 0) {
          returnSettlement[i]['selected'] = false;
        }
      }
    }
    update();
  }

  fatchReturnSettlement() async {
    try {
      bool status = selectedOrder[0]['isActive'] == true ? false : true;
      dynamic jsonReq = {};
      jsonReq["status"] = status;
      if (isReturnSettlementId != "") {
        jsonReq['vendorId'] = isReturnSettlementId;
      }
      var resData = await apis.call(
        apiMethods.returnSettlement,
        jsonReq,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        returnSettlement = resData.data;
      }
      return returnSettlement;
    } catch (e) {
      e;
    }
    update();
  }

  fatchvendorReturnSettlement() async {
    try {
      bool status = selectedOrder[0]['isActive'] == true ? false : true;
      dynamic jsonReq = {};
      jsonReq["status"] = status;
      var resData = await apis.call(
        apiMethods.vendorReturnSettlement,
        jsonReq,
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        returnVendor = resData.data;
      }
      return returnVendor;
    } catch (e) {
      e;
    }
    update();
  }

  onReturnSettlementSelected(String id, String name) async {
    selectedVendorId = [];
    isReturnSettlementId = id;
    isReturnSettlement = name;
    if (isReturnSettlementId != "") {
      await fatchReturnSettlement();
      Get.back();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  // SEND RETRUN SETTLEMENT OTP ......

  _sendOTPReturnOrderSettlement() async {
    try {
      isLoading = true;
      update();
      var request = {
        "ids": selectedVendorId,
      };
      APIDataClass response = await apis.call(
        apiMethods.sendOTPReturnOrderSettlement,
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

  _verifyOTPReturnOrderSettlement() async {
    try {
      isLoading = true;
      update();
      var request = {
        "ids": json.encode(selectedVendorId),
        "otp": controller.text,
        "note": txtDescription.text,
      };
      dioForm.FormData formData = dioForm.FormData.fromMap(request);
      formData.files.add(MapEntry(
        "image",
        await dioForm.MultipartFile.fromFile(
          imageFile!.path,
          filename: imageFile!.path.split("/").last,
        ),
      ));
      APIDataClass response = await apis.call(
        apiMethods.verifyOTPByReturnSettlement,
        formData,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        Get.back();
        onClear();
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

  askForNote() {
    txtDescription.clear();
    controller.clear();
    Get.defaultDialog(
      title: "Note",
      radius: 2,
      barrierDismissible: false,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          border: Border.all(
            color: AppController().appTheme.primary,
            width: 1,
          ),
        ),
        child: TextFormField(
          maxLines: 3,
          controller: txtDescription,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: "Please add note!",
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
            _sendOTPReturnOrderSettlement();
            await imageFromCamera();
            _askForOTP();
          },
          child: const Text("Submit"),
        ),
        TextButton(
          onPressed: () {
            txtDescription.clear();
            Get.back();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  _askForOTP() {
    if (imageFile != null) {
      Get.defaultDialog(
        title: "OTP",
        radius: 2,
        barrierDismissible: false,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: PinFieldAutoFill(
            autoFocus: false,
            codeLength: 4,
            controller: controller,
            onCodeSubmitted: (val) async {
              if (controller.text != "") {
                await _verifyOTPReturnOrderSettlement();
              } else {
                Get.snackbar(
                  "Wrong",
                  "Enter Otp",
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              }
            },
            currentCode: controller.text,
            decoration: UnderlineDecoration(
              textStyle: const TextStyle(fontSize: 20, color: Colors.black),
              colorBuilder: FixedColorBuilder(AppController().appTheme.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _sendOTPReturnOrderSettlement();
            },
            child: const Text("Resend"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    }
  }

  imageFromCamera() async {
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      await _sendOTPReturnOrderSettlement();
      update();
    }
  }
}
