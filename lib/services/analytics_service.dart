import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties({required String userId}) async {
    await _analytics.setUserId(id: userId);
  }

  Future logLogin({required String loginMethod}) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future logEvent(String eventName, {dynamic data}) async {
    //for firebase
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: data,
      );
      if (kDebugMode) {
        print("Firebase Event");
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Firebase Event Error : ${e.toString()}");
      }
    }
  }
}
