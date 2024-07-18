import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:to_do/app/firebase/firebase_config.dart';

class FirebaseAppConfigProd extends FirebaseAppConfig {
  var logger = Logger();
  FirebaseAppConfigProd(super.analytics, super.configs);

  @override
  Future<void> initRemoteConfigDev() async {
    FirebaseRemoteConfig.instance.setDefaults({'important_color': '#FF3B30'});
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 2),
        minimumFetchInterval: const Duration(seconds: 2)));
  }

  @override
  Future<void> initRemoteConfigProd() async {
    FirebaseRemoteConfig.instance.setDefaults({'important_color': '#FF3B30'});
    await FirebaseRemoteConfig.instance.fetchAndActivate();
  }

  @override
  void initCrashlytics() {
    FlutterError.onError = (errorDetails) {
      logger.d('Caught error in FlutterError.onError');
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      logger.d('Caught error in PlatformDispatcher.onError');
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
      );
      return true;
    };
    logger.d('Crashlytics initialized');
  }
}

class FAnalyticProd implements FAnalytic {
  @override
  void analyticDoneEvent() {
    FirebaseAnalytics.instance.logEvent(name: 'done_tap');
  }

  @override
  void analyticDeleteEvent() {
    FirebaseAnalytics.instance.logEvent(name: 'delete_task');
  }

  @override
  void addTaskEvent() {
    FirebaseAnalytics.instance.logEvent(name: 'add_task');
  }

  @override
  void routeToMainScreen() {
    FirebaseAnalytics.instance.logEvent(name: 'route_to_main_screen');
  }

  @override
  void routeToTaskDetailsScreen() {
    FirebaseAnalytics.instance.logEvent(name: 'route_to_task_details_screen');
  }

  @override
  void routeToAddTaskScreen() {
    FirebaseAnalytics.instance.logEvent(name: 'route_to_add_task_screen');
  }

  @override
  void routeToUnknownScreen() {
    FirebaseAnalytics.instance.logEvent(name: 'route_to_unknown_screen');
  }
}

class FRemoteConfigsProd implements FRemoteConfigs {
  @override
  Color getRemoteConfigImportantColor() {
    Color color = HexColor(
      FirebaseRemoteConfig.instance.getString('important_color'),
    );
    return color;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
