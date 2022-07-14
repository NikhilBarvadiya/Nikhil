// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/controller/cod_controller.dart';
import 'package:fw_manager/controller/login_controller.dart';
import 'package:fw_manager/controller/multi_orders_controller.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/controller/return_settlement_controller.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/core/utilities/storage_utils.dart';
import 'package:fw_manager/screen/multi_order/multi_orders_screen.dart';
import 'package:fw_manager/screen/settlement/cod_settlement/cod_settlement_screen.dart';
import 'package:fw_manager/screen/orders/orders_screen.dart';
import 'package:fw_manager/screen/settlement/return_settlement/return_settlement_screen.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  dynamic loginData = Get.arguments;

  dynamic userData;
  bool isSlider = false;
  int selectedIndex = 1;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  getUserData() async {
    userData = await getStorage(Session.userData);
    update();
  }

  List pages = [
    {
      "pageName": "Orders",
      "icon": FontAwesomeIcons.box,
      "screen": const OrdersScreen(),
    },
    {
      "pageName": "Multi Orders",
      "icon": FontAwesomeIcons.boxes,
      "screen": const MultiOrdersScreen(),
    },
    {
      "pageName": "Return Settlement",
      "icon": FontAwesomeIcons.rightLeft,
      "screen": const ReturnSettlementScreen(),
    },
    {
      "pageName": "COD Settlement",
      "icon": FontAwesomeIcons.sackDollar,
      "screen": const CodSettlementScreen(),
    },
  ];

  onSwitchScreen(int i) {
    if (Get.isRegistered<OrdersController>()) {
      Get.delete<OrdersController>();
    }
    if (Get.isRegistered<MultiOrdersController>()) {
      Get.delete<MultiOrdersController>();
    }
    if (Get.isRegistered<ReturnSettlementController>()) {
      Get.delete<ReturnSettlementController>();
    }
    if (Get.isRegistered<CodSettlementController>()) {
      Get.delete<CodSettlementController>();
    }
    selectedIndex = i;
    Get.back();
    update();
  }

  onNotification() {
    Get.toNamed(AppRoutes.notification);
    update();
  }

  onLogout(context) async {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          elevation: 2,
          title: const Text("Are you sure?"),
          content: const Text("Do you really want to logout?"),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                clearStorage();
                LoginController().emailController.clear();
                LoginController().passwordController.clear();
                Get.toNamed(AppRoutes.login);
                update();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
      context: context,
    );
  }
}
