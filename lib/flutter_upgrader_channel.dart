import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_upgrader/flutter_upgrader.dart';

class FlutterUpgradeChanneler {
  static const MethodChannel _channel = MethodChannel('flutter_upgrader');

  // 获取app信息
  static Future<AppInfo> get appInfo async {
    var result = await _channel.invokeMethod('getAppInfo');

    return AppInfo(
      versionName: result['versionName'],
      versionCode: result['versionCode'],
      packageName: result['packageName'],
    );
  }

  // 获取apk下载路径
  static Future<String> get apkDownloadPath async {
    return await _channel.invokeMethod('getApkDownloadPath');
  }

  // Android 安装 app
  static installAppForAndroid(String path) async {
    return await _channel.invokeMethod('install', {'path': path});
  }

  // 获取android手机上安装的应用商店
  static getInstallMarket(List<String>? packageNames) async {
    List<String> packageNameList = AppMarketManager.packageNameList;

    if (packageNames != null && packageNames.isNotEmpty) {
      packageNameList.addAll(packageNames);
    }

    var map = {'packages': packageNameList};
    var result = await _channel.invokeMethod('getInstallMarket', map);

    return ((result as List).map((str) => '$str').toList());
  }

  // 跳转到 ios app store
  static jumpAppStore(String? id, bool? beta) async {
    if (id == null) {
      return;
    }

    final params = {'id': id, 'beta': beta.toString()};
    return await _channel.invokeMethod('jumpAppStore', params);
  }

  // 跳转到应用商店
  static jumpMarket(AppMarketInfo? appMarketInfo) async {
    var map = {
      'marketPackageName': appMarketInfo?.packageName ?? '',
      'marketClassName': appMarketInfo?.className ?? ''
    };

    return await _channel.invokeMethod('jumpMarket', map);
  }
}
