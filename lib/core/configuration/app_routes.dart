import 'package:flutter/material.dart';
import 'package:fw_manager/screen/home/home_screen.dart';
import 'package:fw_manager/screen/login/login_screen.dart';
import 'package:fw_manager/screen/login/splash_screen.dart';
import 'package:fw_manager/screen/map_view_screen.dart';
import 'package:fw_manager/screen/multi_order/assign_driver.dart';
import 'package:fw_manager/screen/multi_order/merge_screen.dart';
import 'package:fw_manager/screen/notification/notification.dart';
import 'package:fw_manager/screen/multi_order/selected_location.dart';
import 'package:fw_manager/screen/orders/edit_orders_screen.dart';
import 'package:fw_manager/screen/orders/new_orders_screen.dart';
import 'package:fw_manager/screen/orders/new_selected_orders_screen.dart';
import 'package:fw_manager/screen/orders/orders_details_screen.dart';
import 'package:fw_manager/screen/orders/orders_location_map.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splash = "/";
  static String login = "/login";
  static String home = "/home";
  static String noInternet = "/noInternet";
  static String selectedLocation = "/selectedLocation";
  static String ordersDetailsScreen = "/ordersDetailsScreen";
  static String newSelectedOrdersScreen = "/newSelectedOrdersScreen";
  static String editOrdersScreen = "/editOrdersScreen";
  static String newOrdersScreen = "/newOrdersScreen";
  static String merge = "/Merge";
  static String assignDriver = "/assignDriver";
  static String mapView = "/mapView";
  static String ordersLocationMap = "/ordersLocationMap";
  static String notification = "/notification";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: ordersDetailsScreen, page: () => const OrdersDetailsScreen()),
    GetPage(name: newSelectedOrdersScreen, page: () => NewSelectedOrdersScreen()),
    GetPage(name: editOrdersScreen, page: () => EditOrdersScreen()),
    GetPage(name: newOrdersScreen, page: () => NewOrdersScreen()),
    GetPage(name: selectedLocation, page: () => SelectedLocation()),
    GetPage(name: merge, page: () => const MergeScreen()),
    GetPage(name: assignDriver, page: () => const AssignDriverScreen()),
    GetPage(name: mapView, page: () => const MapViewScreen()),
    GetPage(name: noInternet, page: () => const Center(child: Text("No internet found"))),
    GetPage(name: ordersLocationMap, page: () => const OrdersLocationMap()),
    GetPage(name: notification, page: () => NotificationScreen()),
  ];
}
