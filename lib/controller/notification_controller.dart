import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController with GetSingleTickerProviderStateMixin {
  bool isNotification = false;
  bool isSlider = true;

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Today'),
    const Tab(text: 'All'),
  ];
  TabController? controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void onClose() {
    controller!.dispose();
    super.onClose();
  }

  List<dynamic> notificationTodayList = [
    for (int i = 0; i < 15; i++)
      {
        "header": "Jess Raddon mention you in Tennis List",
        "time": "1${i}h ago * Hobby List",
      }
  ];

  List<dynamic> notificationAllList = [
    for (int i = 0; i < 20; i++)
      {
        "header": "Anna Srzand joined to Final Presentation",
        "time": "1${i}h ago * Hobby List",
      }
  ];
}
