import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/common_controller.dart';
import 'package:fw_manager/core/configuration/app_config.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseNotificationService.init();
  // FirebaseNotificationService().requestPermissions();
  await GetStorage.init();

  Get.put(CommonController());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey.shade50,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, _) => GetMaterialApp(
        builder: (BuildContext context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        title: AppConfig.appName,
        enableLog: AppConfig.enableLog,
        debugShowCheckedModeBanner: AppConfig.debugBanner,
        theme: AppTheme.fromType(ThemeType.light).themeData,
        darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
        themeMode: ThemeService().theme,
        getPages: AppRoutes.getPages,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
