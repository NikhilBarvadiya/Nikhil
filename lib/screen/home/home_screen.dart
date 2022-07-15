// ignore_for_file: prefer_final_fields, prefer_const_constructors
// ignore_for_file: deprecated_member_use
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/common_controller.dart';
import 'package:fw_manager/controller/home_controller.dart';
import 'package:fw_manager/controller/login_controller.dart';
import 'package:fw_manager/core/assets/index.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/core/utilities/index.dart';
import 'package:fw_manager/core/widgets/common_widgets/menu_card.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());
  CommonController _commonController = Get.find();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _commonController.statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return GetBuilder<HomeController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return homeController.isSlider;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: true,
            foregroundColor: Colors.white,
            title: Text(
              homeController.pages[homeController.selectedIndex]["pageName"].toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
              textScaleFactor: 1,
              textAlign: TextAlign.center,
            ),
          ),
          body: homeController.pages[homeController.selectedIndex]["screen"],
          drawer: SizedBox(
            width: Get.width * 0.85,
            child: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppController().appTheme.primary1.withOpacity(.9),
                          AppController().appTheme.primary.withOpacity(.9),
                        ],
                      ),
                    ),
                    currentAccountPicture: Image.asset(
                      imageAssets.avatar,
                      fit: BoxFit.fill,
                    ),
                    accountName: Text(
                      homeController.userData != null ? homeController.userData['email'] : 'NA',
                      style: TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      homeController.userData != null
                          ? homeController.userData['type'] == 'admin'
                              ? 'Administrator'
                              : 'Manager'
                          : 'NA',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0),
                      children: [
                        for (int i = 0; i < homeController.pages.length; i++)
                          MenuCard(
                            title: homeController.pages[i]["pageName"].toString(),
                            icon: homeController.pages[i]["icon"],
                            onPress: () => homeController.onSwitchScreen(i),
                          ),
                        MenuCard(
                          icon: Icons.notifications_active,
                          title: "Notification",
                          onPress: () => Get.toNamed(AppRoutes.notification),
                        ),
                        MenuCard(
                          icon: FontAwesomeIcons.rightFromBracket,
                          title: "Log out",
                          onPress: () => homeController.onLogout(context),
                        ),
                        SizedBox(height: appScreenUtil.size(20)),
                        Center(
                          child: Text(
                            "Support".toUpperCase(),
                            style: TextStyle(
                              color: AppController().appTheme.accentTxt,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: appScreenUtil.size(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String link = "tel:6357017016";
                                await launch(link);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width * 0.05),
                            GestureDetector(
                              onTap: () async {
                                String link = "https://wa.me/916357017016";
                                await launch(link);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.whatsapp,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width * 0.05),
                            GestureDetector(
                              onTap: () async {
                                String link = "mailto:contact@fastwhistle.com";
                                await launch(link);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.mail_outline_rounded,
                                    color: Colors.deepOrange[200],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: appScreenUtil.size(10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
