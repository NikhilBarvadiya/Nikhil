import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/core/utilities/index.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  setUserData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Sentry.configureScope((scope) async {
      var id = getStorage(Session.id).toString();
      var name = getStorage(Session.userName).toString();

      // ignore: deprecated_member_use
      scope.user = SentryUser(
        id: id,
        username: name,
        extras: {
          'Package Name': packageInfo.packageName,
          'App Version': packageInfo.version,
          'Build number': packageInfo.buildNumber,
        },
      );
    });
  }
}
