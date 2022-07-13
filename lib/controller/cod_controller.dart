// ignore_for_file: deprecated_member_use, must_call_super, empty_catches, avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/model/api_data_class.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class CodSettlementController extends GetxController {
  final txtDescription = TextEditingController();
  TextEditingController controller = TextEditingController();
  String selectedCod = "By Vendor";
  bool vendorFilter = false;
  bool driverFilter = false;
  bool personNameSelect = false;
  bool driverNameSelect = false;
  bool returnOrderFilter = false;
  List<dynamic> driverNameList = [];
  List<dynamic> driversList = [];
  List<dynamic> vendorNameList = [];
  List<dynamic> vendorList = [];
  List selectedVendorsCOD = [];
  String startDateVendor = "";
  String endDateVendor = "";
  String startDateDriver = "";
  String endDateDriver = "";
  dynamic sendOTP;
  dynamic returnOrderOtp;
  File? imageFile;

  bool isLoading = false;

  @override
  void onInit() {
    vendorFilter = false;
    driverFilter = false;
    onDriverApiCalling();
  }

  List codList = [
    {
      "cod": "By Vendor",
      "isActive": true,
    },
    {
      "cod": "By Drivers",
      "isActive": false,
    }
  ];

  onDriverApiCalling() async {
    if (codList[0]['isActive'] == true) {
      await _fetchVendorCODSettlement();
    }
    if (codList[1]['isActive'] == true) {
      await _fetchDriverCODSettlement();
    }
    update();
  }

  _fetchDriverCODSettlement() async {
    try {
      var resData = await apis.call(
        apiMethods.driverGetDetails,
        {},
        ApiType.post,
      );
      if (resData.isSuccess == true) {
        driverNameList = resData.data;
      }
      return driverNameList;
    } catch (e) {}
    update();
  }

  fatchDriverDetails(driverId) async {
    try {
      var resData = await apis.call(
        apiMethods.driversDetails,
        {
          "driverId": driverId,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        driversList = resData.data;
      }
      print("driverList====>$driversList");
      print("driverList====>${driversList[0]["desc"]}");
      return driversList;
    } catch (e) {}
    update();
  }

  _fetchVendorCODSettlement() async {
    try {
      var resData = await apis.call(
        apiMethods.vendorGetDetails,
        {},
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        vendorNameList = resData.data;
      }
      return vendorNameList;
    } catch (e) {}
    update();
  }

  fatchVendorDetails(vendorId) async {
    try {
      var resData = await apis.call(
        apiMethods.vendorDetails,
        {
          "vendorId": vendorId,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        vendorList = resData.data;
        print("dataset");
        print(vendorList[0].toString());
      }
      return vendorList;
    } catch (e) {}
    update();
  }

  onChange(int i) {
    for (int a = 0; a < codList.length; a++) {
      if (a == i) {
        codList[a]["isActive"] = true;
        selectedCod = codList[a]["cod"];
      } else {
        codList[a]["isActive"] = false;
      }
    }
    onDriverApiCalling();
    update();
  }

  String selectedVendor = "";
  onPersonNameClick(i) async {
    personNameSelect = true;
    selectedVendorsCOD = [];
    selectedVendor = vendorNameList[0]["data"][i]["_id"];
    await fatchVendorDetails(vendorNameList[0]["data"][i]["_id"]);
    update();
  }

  onDriverNameClick(i) async {
    driverNameSelect = true;
    await fatchDriverDetails(driverNameList[0]["data"][i]["_id"]);
    update();
  }

  onBackButton() {
    startDateDriver = "";
    endDateDriver = "";
    personNameSelect = false;
    driverNameSelect = false;
    update();
  }

  onDatePickerVendor() async {
    vendorFilter = true;
    update();
    await dateVendorTimeRangePicker(Get.context!);
  }

  dateVendorTimeRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Select a Date or Date-Range',
      initialDateRange: DateTimeRange(
        end: DateTime.now(),
        start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
      ),
    );

    if (picked != null) {
      startDateVendor = picked.start.toIso8601String();
      endDateVendor = picked.end.toIso8601String();
      update();
    }
  }

  onDatePickerDriver() async {
    driverFilter = true;
    update();
    await dateDodTimeRangePicker(Get.context!);
  }

  dateDodTimeRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Select a Date or Date-Range',
      initialDateRange: DateTimeRange(
        end: DateTime.now(),
        start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
      ),
    );

    if (picked != null) {
      startDateDriver = picked.start.toIso8601String();
      endDateDriver = picked.end.toIso8601String();
      update();
    }
  }

  addToSelectedList(item) {
    int index = selectedVendorsCOD.indexOf(item);
    if (index == -1) {
      selectedVendorsCOD.add(item);
    } else {
      selectedVendorsCOD.remove(item);
    }
    _autoSelector();
  }

  _autoSelector() {
    for (int i = 0; i < vendorList.length; i++) {
      var existing = selectedVendorsCOD.where((element) => element['_id'] == vendorList[i]["_id"]).toList();
      if (existing.length == 1) {
        vendorList[i]['selected'] = true;
      } else {
        vendorList[i]['selected'] = false;
      }
    }
    update();
  }

  //ASK FOR OTP TO VENDOR FOR CASH SETTLEMENT
  _sendOTPVendorCashSettlement() async {
    try {
      isLoading = true;
      update();
      var request = {
        "transactions": selectedVendorsCOD,
        "receiverId": selectedVendor,
        "desc": txtDescription.text,
      };
      APIDataClass response = await apis.call(
        apiMethods.sendOTPVendorCashSettlement,
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
    } catch (err) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          err.toString(),
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
            await _sendOTPVendorCashSettlement();
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
              // await fatchReturnOrderOtp();
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
            await _sendOTPVendorCashSettlement();
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
