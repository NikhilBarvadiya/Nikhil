import 'package:fw_manager/core/configuration/app_routes.dart';import 'package:get/get.dart';class SplashController extends GetxController{  String? version;  @override  void onInit() {    Future.delayed(const Duration(seconds: 2),(){      Get.toNamed(AppRoutes.login);    });    super.onInit();  }}