// ignore_for_file: deprecated_member_use, must_call_super, empty_catches, avoid_print

import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';

class CodSettlementController extends GetxController {
  String selectedCod = "By Vendor";
  bool vendorFilter = false;
  bool driverFilter = false;
  bool personNameSelect = false;
  bool driverNameSelect = false;

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

  onDriverApiCalling() {
    if (codList[0]['isActive'] == true) {
      fatchVendorCodSettlement();
    }
    if (codList[1]['isActive'] == true) {
      fatchDriverCodSettlement();
    }
    update();
  }

  List<dynamic> driverNameList = [];

  fatchDriverCodSettlement() async {
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

  List<dynamic> driversList = [];

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

  List<dynamic> vendorNameList = [];

  fatchVendorCodSettlement() async {
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

  List<dynamic> vendorList = [];
  String diffAmount = "";
  String collectableCash = "";
  String cashReceive = "";

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
      }
      cashReceive = vendorList[0]["orderDetails"]["cashReceive"].toString();
      collectableCash = vendorList[0]["orderDetails"]["collectableCash"].toString();
      diffAmount = (collectableCash).compareTo(collectableCash).toString();
      print("=====diffAmount===================$diffAmount");
      print("=====cashReceive===================$cashReceive");
      print("======collectableCash==================$collectableCash");
      print("desc======>${vendorList[0]["orderDetails"]["orderNo"]}");
      print("collectableCash======>${vendorList[0]["orderDetails"]["collectableCash"]}");
      print("deferenceAmount======>${vendorList[0]["orderDetails"]["deferenceAmount"]}");
      print("cashReceive======>${vendorList[0]["orderDetails"]["cashReceive"]}");
      print("driverId======>${vendorList[0]["orderDetails"]["driverId"]["name"]}");
      print("name======>${vendorList[0]["orderDetails"]["vendorOrderStatusId"]["addressId"]["name"]}");
      print("person======>${vendorList[0]["orderDetails"]["vendorOrderStatusId"]["addressId"]["person"]}");
      return vendorList;
    } catch (e) {}
    update();
  }

  @override
  void onInit() {
    fatchVendorCodSettlement();
    fatchDriverCodSettlement();
    vendorFilter = false;
    driverFilter = false;
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
    update();
  }

  onPersonNameClick(i) async {
    personNameSelect = true;
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

  /// By vendor ///

  onDatePickerVendor() async {
    vendorFilter = true;
    update();
    await dateVendorTimeRangePicker(Get.context!);
  }

  String startDateVendor = "";
  String endDateVendor = "";

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

  /// By driver ///

  onDatePickerDriver() async {
    driverFilter = true;
    update();
    await dateDodTimeRangePicker(Get.context!);
  }

  String startDateDriver = "";
  String endDateDriver = "";

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
}
