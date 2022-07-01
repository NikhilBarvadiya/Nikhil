// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';

class VendorSettlementController extends GetxController {
  String vendorSelectedOrder = "Return order";
  bool returnOrderFilter = false;
  // bool codOrderFilter = false;

  @override
  void onInit() async {
    await fatchReturnSettlement();
    returnOrderFilter = false;
    // codOrderFilter = false;
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

  // List codLocation = [
  //   for (int i = 1; i < 11; i++)
  //     {
  //       "id": "$i Pending to collect COD Location",
  //       "orderNo": "#VND-00608$i",
  //       "place": "Order Placing Time",
  //       "dateTime": "Apr 25, 2022, 4:23:08 PM",
  //     }
  // ];

  List returnLocation = [
    for (int i = 1; i < 11; i++)
      {
        "id": "$i Returned Location",
        "orderNo": "#VND-00563$i",
        "place": "Order Placing Time",
        "dateTime": "Apr 13, 2022, 10:45:47 AM",
      }
  ];

  onChange(int i) {
    for (int a = 0; a < selectedOrder.length; a++) {
      if (a == i) {
        selectedOrder[a]["isActive"] = true;
        vendorSelectedOrder = selectedOrder[a]["selectedOrder"];
        fatchReturnSettlement();
      } else {
        selectedOrder[a]["isActive"] = false;
      }
    }
    update();
  }

  onDatePickerReturn() async {
    returnOrderFilter = true;
    update();
    await dateVendorTimeRangePicker(Get.context!);
  }

  String startDateReturnOrder = "";
  String endDateReturnOrder = "";

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
      startDateReturnOrder = picked.start.toIso8601String();
      endDateReturnOrder = picked.end.toIso8601String();
      update();
    }
  }

  dynamic returnSettlement;
  fatchReturnSettlement() async {
    print("hello");
    try {
      var resData = await apis.call(
        apiMethods.returnSettlement,
        {
          "status": selectedOrder[0]['isActive'] == true
              ? true
              : selectedOrder[1]['isActive'] == true
                  ? false
                  : true,
          "vendorId": "",
        },
        ApiType.post,
      );
      print("hello");
      if (resData.isSuccess == true && resData.data != 0) {
        returnSettlement = resData.data;
      }
      print("driverList====>$returnSettlement");
      return returnSettlement;
    } catch (e) {}
    update();
  }

  /// COD order ///

  // onDatePickerCod() async {
  //   codOrderFilter = true;
  //   update();
  //   await dateDodTimeRangePicker(Get.context!);
  // }

  // String startDateCodOrder = "";
  // String endDateCodOrder = "";

  // dateDodTimeRangePicker(BuildContext context) async {
  //   DateTimeRange? picked = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime.now().subtract(const Duration(days: 90)),
  //     lastDate: DateTime.now(),
  //     helpText: 'Select a Date or Date-Range',
  //     initialDateRange: DateTimeRange(
  //       end: DateTime.now(),
  //       start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
  //     ),
  //   );

  //   if (picked != null) {
  //     startDateCodOrder = picked.start.toIso8601String();
  //     endDateCodOrder = picked.end.toIso8601String();
  //     update();
  //   }
  // }
}
