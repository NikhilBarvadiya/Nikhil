import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersController extends GetxController {
  String selectedFilter = "Pending";
  bool isdragDrop = false;
  bool isSlider = true;
  List filters = [
    {
      "icon": Icons.pending_actions,
      "label": "Pending",
      "isActive": true,
    },
    {
      "icon": Icons.running_with_errors,
      "label": "Running",
      "isActive": false,
    },
    {
      "icon": Icons.fact_check_outlined,
      "label": "Complete",
      "isActive": false,
    },
    {
      "icon": Icons.cancel,
      "label": "Cancelled",
      "isActive": false,
    }
  ];

  List<dynamic> selectedOrders = [
    for (int i = 1; i < 11; i++)
      {
        "orderNo": "#ORD-00507$i",
        "orderDateTime": "Jun 10, 2022, 10:19:52 AM",
        "customerName": "Fastwhistle : ",
        "customerNumber": " +91 6357017016",
        "pickupStop": "5 Stops",
        "amount": "₹253",
        "amountType": i == 0
            ? "C"
            : i == 2
                ? "W"
                : i == 5
                    ? "R"
                    : "C",
        "status": " Pending",
        "requestedVehicle": "CHAUHAN RAHUL KANAHAIYA",
        "_id": i,
      },
  ];

  List<dynamic> orderList = [
    for (int i = 0; i < 11; i++)
      {
        "header": i == 0
            ? "Pickup"
            : i == 10
                ? "Drop"
                : "Stop$i",
        "time": " 3 Minutes",
        "shopName": "Shreeji Pharmacy (Lal Darwaja)",
        "personName": "(R19-87${i}7) ",
        "number": "6353017016",
        "address": "R-9, Nr.Shyam Nagar Ni Wadi L.H. Road L H Road, Minibazar Varachha",
        "otp": "1234",
        "note": "R-9-10-11",
        "status": i == 1
            ? "Pending"
            : i == 2
                ? "Running"
                : i == 4
                    ? "Complete"
                    : i == 7
                        ? "Cancelled"
                        : "Pending",
        "dateTime": "10/01/22,10:19 AM",
        "amount": "₹37$i",
        "amount1": "₹375",
      }
  ];

  onRecord(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = orderList[0].removeAt(oldIndex);
    orderList[0].insert(newIndex, item);
    update();
  }

  @override
  void onInit() {
    fatchOrders();
    super.onInit();
  }

  onChange(int i) {
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        selectedFilter = filters[a]["label"];
        fatchOrders();
      } else {
        filters[a]["isActive"] = false;
      }
    }
    update();
  }

  onRefresh() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => selectedOrders.addAll(selectedOrders[0]),
    );
  }

  onDetailsTap(dynamic data) {
    Get.toNamed(AppRoutes.ordersDetailsScreen, arguments: data);
    update();
  }

  onMap() {
    update();
  }

  onBack() {
    Get.back();
    isdragDrop = !isdragDrop;
    update();
  }

  void openEditDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit orders details'),
        actions: [
          ListTile(
            title: const Text("Edit"),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.editOrdersScreen);
              update();
            },
          ),
          ListTile(
            title: const Text("Drag And Drop"),
            onTap: () {
              isdragDrop = !isdragDrop;
              update();
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Send To Driver"),
            onTap: () async {
              String link = "https://wa.me/916357017016";
              // ignore: deprecated_member_use
              await launch(link);
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Add New"),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.newOrdersScreen);
              update();
            },
          ),
        ],
      ),
    );
  }

  List selectedOrderList = [];

  fatchOrders() async {
    try {
      var resData = await apis.call(
        apiMethods.orders,
        {
          "page": 1,
          "limit": 10,
          "search": "",
          "type": "Pending",
          "fromDate": null,
          "toDate": null,
          "searchFilter": "3",
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        selectedOrderList = resData.data;
      }
      return selectedOrderList;
    } catch (e) {
      return null;
    }
  }
}
