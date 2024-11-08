一个 Flutter 应用升级插件, 支持 Android 和 IOS, 插件的构思和设计来均自于 [flutter_app_upgrade](https://github.com/LaoMengFlutter/flutter-do/tree/master/flutter_app_upgrade)

# 安装

1. 在 `pubspec.yaml` 添加

   ```
    dependencies:
      flutter_upgrader: ^1.1.8
   ```

2. 在命令行运行如下

   ```
    flutter pub get
   ```

# 使用

## Android

1. 在 `android/app/src/main/AndroidManifest.xml` 添加 provider

   ```xml
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
      xmlns:tools="http://schemas.android.com/tools"
      package="com.xxxx.xxxxx"
    >
      <application>
        ...
        <provider
          android:name="androidx.core.content.FileProvider"
          android:authorities="${applicationId}.fileprovider"
          android:grantUriPermissions="true"
          android:exported="false"
        >
          <meta-data
            android:name="android.support.FILE_PROVIDER_PATHS"
            android:resource="@xml/file_paths"
          />
        </provider>
      </application>
    </manifest>
   ```

2. 新增 `android/app/src/main/res/xml/file_paths.xml` 文件

   ```xml
    <paths>
      <external-path
        name="external-path"
        path="."
      />

      <external-cache-path
        name="external-cache-path"
        path="."
      />

      <external-files-path
        name="external-files-path"
        path="."
      />

      <files-path
        name="files_path"
        path="."
      />

      <cache-path
        name="cache-path"
        path="."
      />

      <root-path
        name="name"
        path="."
      />
    </paths>
   ```

3. 点击升级前往应用商店

   ```dart
    // 一般通过远程接口调用获取
    final Future<AppUpgradeInfo> appUpgradeInfo = Future.value(
      AppUpgradeInfo(
        title: '更新提示',
        contents: ['有新版本哟,请更新～', '修复了设备定位bug', '优化认证操作体验'],
        force: true, // 是否强制升级
      ),
    );

    // 获取已上架的应用市场, 根据应用包名，例: 'com.flutter.app'
    final appMarketInfos = AppMarketManager.getAppMarketList(
      await FlutterUpgradeChanneler.getInstallMarket(['com.flutter.app']),
    );

    // 升级应用 Api
    AppUpgradeManager.upgrade(
      context, // BuildContext
      appUpgradeInfo,
      appMarketInfo: appMarketInfos[0],
      onCancel: () {},
      onOk: () {},
    );
   ```

  <p align="center">
    <img 
      style="width: 350px; margin-left: 35px;" 
      src="https://linpengteng.github.io/resource/flutter-upgrader/android_upgrader.png"
    >
  </p>

4. 从指定的 Url 下载 apk

   ```dart
    // 一般通过远程接口调用获取
    final Future<AppUpgradeInfo> appUpgradeInfo = Future.value(
      AppUpgradeInfo(
        title: '更新提示',
        contents: ['有新版本哟,请更新～', '修复了设备定位bug', '优化认证操作体验'],
        force: true, // 是否强制升级
      ),
    );

    // 升级应用 Api
    AppUpgradeManager.upgrade(
      context, // BuildContext
      appUpgradeInfo,
      apkDownloadUrl: 'http://xxx.xxx.com/upgrade.apk',
      onCancel: () {},
      onOk: () {},
    );
   ```

  <p align="center">
    <img 
      style="width: 350px; margin-left: 35px;" 
      src="https://linpengteng.github.io/resource/flutter-upgrader/android_upgrader.gif"
    >
  </p>

## IOS

1. 点击升级前往应用商店

   ```dart
    // 一般通过远程接口调用获取
    final Future<AppUpgradeInfo> appUpgradeInfo = Future.value(
      AppUpgradeInfo(
        title: '更新提示',
        contents: ['有新版本哟,请更新～', '修复了设备定位bug', '优化认证操作体验'],
        force: true, // 是否强制升级
      ),
    );

    // 升级应用 Api
    AppUpgradeManager.upgrade(
      context, // BuildContext
      appUpgradeInfo,
      iosAppId: 'xxxxxxxx', // ios appId
      onCancel: () {},
      onOk: () {},
    );
   ```

  <p align="center">
    <img 
      style="width: 350px; margin-left: 35px;" 
      src="https://linpengteng.github.io/resource/flutter-upgrader/ios_upgrader.png"
    >
  </p>
