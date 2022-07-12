import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VendorSettlementController extends GetxController {
  String vendorSelectedOrder = "Return order";
  bool returnOrderFilter = false;
  final notController = TextEditingController();
  TextEditingController controller = TextEditingController();
  File? imageFile;

  @override
  void onInit() {
    fatchReturnSettlement();
    fatchvendorReturnSettlement();
    _autoSelector();
    returnOrderFilter = false;
    isReturnSettlement = "";
    isReturnSettlementId = "";
    notController.clear();
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

  onChange(int i) async {
    for (int a = 0; a < selectedOrder.length; a++) {
      if (a == i) {
        selectedOrder[a]["isActive"] = true;
        isReturnSettlement = "";
        isReturnSettlementId = "";
        vendorSelectedOrder = selectedOrder[a]["selectedOrder"];
        await fatchReturnSettlement();
        await fatchvendorReturnSettlement();
      } else {
        selectedOrder[a]["isActive"] = false;
        selectedVendorId.clear();
      }
    }
    update();
  }

  List selectedVendorId = [];

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

  List returnSettlement = [];
  String isReturnSettlement = "";
  String isReturnSettlementId = "";

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

  dynamic returnVendor;

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
    isReturnSettlementId = id;
    isReturnSettlement = name;
    if (isReturnSettlementId != "") {
      await fatchReturnSettlement();
      // _autoSelector();
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

  dynamic sendOTP;

  fatchSendOTP() async {
    try {
      var resData = await apis.call(
        apiMethods.sendOTP,
        {
          "ids": selectedVendorId,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        sendOTP = resData.data;
      }
      return sendOTP;
    } catch (e) {
      e;
    }
    update();
  }

  dynamic returnOrderOtp;

  fatchReturnOrderOtp() async {
    try {
      File signatureFile = await imageFromUInit8List(imageFile as Uint8List);
      var resData = await apis.call(
        apiMethods.returnOrderOtp,
        {
          "ids": selectedVendorId,
          "otp": controller.text,
          "note": notController.text,
          "image": signatureFile,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        returnOrderOtp = resData.data;
      }
      return returnOrderOtp;
    } catch (e) {
      return "";
    }
  }

  onSendOTP() {
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
          maxLines: 5,
          controller: notController,
          decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: InputBorder.none, hintText: "Do you know?"),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (notController.text != "") {
              imageFromCamera();
              Get.back();
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
                      onCodeSubmitted: (val) async {
                        if (controller.text != "") {
                          await fatchReturnOrderOtp();
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
                        await fatchSendOTP();
                      },
                      child: const Text("Resend"),
                    ),
                    TextButton(
                      onPressed: () {
                        notController.clear();
                        update();
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                );
              }
            }
            update();
          },
          child: const Text("Ok"),
        ),
        TextButton(
          onPressed: () {
            notController.clear();
            update();
            Get.back();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
    update();
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
      await fatchSendOTP();
      update();
    }
  }

  Future<File> imageFromUInit8List(Uint8List imageUInt8List) async {
    Uint8List tempImg = imageUInt8List;
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/signatureImage.jpg').create();
    file.writeAsBytesSync(tempImg);
    return file;
  }
}
