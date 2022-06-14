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
import 'package:sentry_flutter/sentry_flutter.dart';

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
  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://86b9c7af4e9a474db9803c4205d72123@o1089444.ingest.sentry.io/6104561';
    },
    appRunner: () => runApp(const MyApp()),
  );
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
