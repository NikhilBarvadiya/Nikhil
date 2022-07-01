import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:get/get.dart';

class NewOrderController extends GetxController {
  String selectedOrder = "B2B Order";
  bool isSlider = true;
  bool isOpenTap = false;
  bool isOpenOrder = false;
  List selectedOrderTrueList = [];

  onOpenTap() {
    isOpenTap = !isOpenTap;
    update();
  }

  onCloseTap() {
    isOpenOrder = !isOpenOrder;
    update();
  }

  onNewSelectedOrders() {
    Get.toNamed(AppRoutes.newSelectedOrdersScreen);
    update();
  }

  onChangeOrder(int i) {
    for (int a = 0; a < order.length; a++) {
      if (a == i) {
        order[a]["isActive"] = true;
        selectedOrder = order[a]["order"];
      } else {
        order[a]["isActive"] = false;
      }
    }
    update();
  }

  List order = [
    {
      "order": "B2B Orders",
      "isActive": true,
    },
    {
      "order": "B2C Orders",
      "isActive": false,
    },
  ];

  List selectedAddress = [
    for (int i = 1; i < 11; i++) {"shopName": "WELL NATURES HEALTH CARE $i", "personName": "R27-1000$i", "number": "9898849850", "address": "R-27 KIMAVATI COMPLEX,SHOP NO.71,AT.KIM(EAST),TA.OLPAD,SURAT.", "Vendor": "SHREE HARI PHARMA", "selected": false}
  ];

  addToSelectedList(item) {
    if (item != null) {
      var index = selectedOrderTrueList.indexOf(item);
      if (kDebugMode) {
        print(index);
      }
      if (index == -1) {
        selectedOrderTrueList.add(item);
        update();
      }
      _autoSelector();
    }
  }

  removeToSelectedList(item) {
    if (item != null) {
      Get.dialog(
        AlertDialog(
          title: Text(
            'Remove',
            style: AppCss.h1,
          ),
          content: Text(
            'Do you remove this location?',
            style: AppCss.h3,
          ),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                selectedOrderTrueList.remove(item);
                _autoSelector();
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Close"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }

  _autoSelector() {
    for (int i = 0; i < selectedAddress.length; i++) {
      var data = selectedOrderTrueList.where((element) => element['personName'] == selectedAddress[i]['personName']);
      if (kDebugMode) {
        print(data);
      }
      if (data.isNotEmpty) {
        selectedAddress[i]['selected'] = true;
      } else {
        selectedAddress[i]['selected'] = false;
      }
      update();
    }
  }
}
