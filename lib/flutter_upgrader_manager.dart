import 'package:flutter/material.dart';
import 'package:flutter_upgrader/flutter_upgrader.dart';
import 'package:flutter_upgrader/flutter_upgrader_view.dart';

class AppUpgradeManager {
  static upgrade(
    BuildContext context,
    Future<AppUpgradeInfo> future, {
    TextStyle? titleStyle,
    TextStyle? versionStyle,
    TextStyle? contentStyle,
    EdgeInsets? contentPadding,
    String? cancelText,
    TextStyle? cancelTextStyle,
    String? okText,
    TextStyle? okTextStyle,
    List<Color>? okBackgroundColors,
    Color? progressBarColor,
    double borderRadius = 20.0,
    String? iosAppId,
    AppMarketInfo? appMarketInfo,
    DividerThemeData? dividerTheme,
    DownloadProgressCallback? downloadProgress,
    DownloadStatusChangeCallback? downloadStatusChange,
    VoidCallback? onCancel,
    VoidCallback? onOk,
    bool? beta,
  }) {
    future.then((AppUpgradeInfo appUpgradeInfo) {
      if (!context.mounted) {
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          okBackgroundColors ??= [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor
          ];

          return DividerTheme(
            data: dividerTheme ?? DividerTheme.of(context),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
              ),
              child: SimpleUpgradeViewWidget(
                title: appUpgradeInfo.title,
                version: appUpgradeInfo.version,
                contents: appUpgradeInfo.contents,
                titleStyle: titleStyle,
                versionStyle: versionStyle,
                contentStyle: contentStyle,
                contentPadding: contentPadding,
                progressBarColor: progressBarColor,
                borderRadius: borderRadius,
                downloadUrl: appUpgradeInfo.apkDownloadUrl,
                headers: appUpgradeInfo.headers,
                force: appUpgradeInfo.force,
                iosAppId: iosAppId,
                appMarketInfo: appMarketInfo,
                downloadProgress: downloadProgress,
                downloadStatusChange: downloadStatusChange,
                okBackgroundColors: okBackgroundColors,
                cancelTextStyle: cancelTextStyle,
                okTextStyle: okTextStyle,
                cancelText: cancelText,
                onCancel: onCancel,
                okText: okText,
                onOk: onOk,
                beta: beta,
              ),
            ),
          );
        },
      );
    }).catchError((error) {
      debugPrint('$error');
    });
  }
}

// AppInfo
class AppInfo {
  AppInfo({
    required this.versionName,
    required this.versionCode,
    required this.packageName,
  });

  final String versionName;
  final String versionCode;
  final String packageName;
}

// AppUpgradeInfo
class AppUpgradeInfo {
  AppUpgradeInfo({
    required this.title,
    required this.contents,
    this.apkDownloadUrl,
    this.force = false,
    this.headers,
    this.version,
  });

  final dynamic title;
  final String? version;
  final List<String> contents;
  final Map<String, dynamic>? headers;
  final String? apkDownloadUrl;
  final bool force;
}

// 下载进度回调
typedef DownloadProgressCallback = Function(
  int count,
  int total,
);

// 下载状态变化回调
typedef DownloadStatusChangeCallback = Function(
  DownloadStatus downloadStatus, {
  dynamic error,
});
