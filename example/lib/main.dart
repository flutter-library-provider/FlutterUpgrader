import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_upgrader/flutter_upgrader.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Upgrader Plugin'),
      ),
      body: DividerTheme(
        data: const DividerThemeData(color: Colors.red), // support
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          alignment: Alignment.topCenter,
          child: const UpgradeButton(),
        ),
      ),
    );
  }
}

class UpgradeButton extends StatelessWidget {
  const UpgradeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButtonTheme.of(context).style,
      child: Container(
        width: 270,
        height: 44,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(12.0),
        child: const Text(
          '升 级',
          style: TextStyle(fontSize: 18),
        ),
      ),
      onPressed: () {
        final Future<AppUpgradeInfo> appUpgradeInfo = Future.value(
          AppUpgradeInfo(
            title: '更新提示',
            contents: ['有新版本哟,请更新～'],
            force: true,
          ),
        );

        if (Platform.isAndroid) {
          AppUpgradeManager.upgrade(
            context,
            appUpgradeInfo,
            appMarketInfo: AppMarketManager.huaWei,
            // dividerTheme: const DividerThemeData(color: Colors.blue), // support
          );
        }

        if (Platform.isIOS) {
          AppUpgradeManager.upgrade(
            context,
            iosAppId: '',
            appUpgradeInfo,
            // dividerTheme: const DividerThemeData(color: Colors.blue), // support
          );
        }
      },
    );
  }
}
