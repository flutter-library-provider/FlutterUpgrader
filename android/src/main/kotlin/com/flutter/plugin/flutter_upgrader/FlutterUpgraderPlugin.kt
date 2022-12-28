package com.flutter.plugin.flutter_upgrader

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File


class FlutterUpgraderPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var mainContext: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    mainContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_upgrader")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method){
      "getAppInfo" -> {
        getAppInfo(mainContext, result)
      }
      "getApkDownloadPath" -> {
        result.success(mainContext.getExternalFilesDir("")?.absolutePath)
      }
      "install" -> {
        call.argument<String>("path")?.also { startInstall(mainContext, it) }
      }
      "getInstallMarket" -> {
        result.success(getInstallMarket(mainContext, call.argument<List<String>>("packages")))
      }
      "jumpMarket" -> {
        val marketPackageName = call.argument<String>("marketPackageName")
        val marketClassName = call.argument<String>("marketClassName")
        jumpMarket(mainContext, marketPackageName, marketClassName)
      }
      else -> result.notImplemented()
    }
  }


  /**
   * 获取app信息
   */
  fun getAppInfo(context: Context?, result: Result) {
    context?.also {
      val packageInfo = it.packageManager.getPackageInfo(it.packageName, 0)
      val map = HashMap<String, String>()

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        map["packageName"] = packageInfo.packageName
        map["versionName"] = packageInfo.versionName
        map["versionCode"] = "${packageInfo.longVersionCode}"
      } else {
        map["packageName"] = packageInfo.packageName
        map["versionName"] = packageInfo.versionName
        map["versionCode"] = "${packageInfo.versionCode}"
      }

      result.success(map)
    }
  }


  /**
   * 直接跳转到指定应用市场
   */
  fun jumpMarket(context: Context, marketPackageName: String?, marketClassName: String?) {
    try {
      val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
      val uri = Uri.parse("market://details?id=${packageInfo.packageName}")
      val nameEmpty = marketPackageName == null || marketPackageName.isEmpty()
      val classEmpty = marketClassName == null || marketClassName.isEmpty()
      val goToMarket = Intent(Intent.ACTION_VIEW, uri)

      if (nameEmpty || classEmpty) {
        goToMarket.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      } else {
        goToMarket.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        goToMarket.setClassName(marketPackageName!!, marketClassName!!)
      }
      context.startActivity(goToMarket)
    } catch (e: ActivityNotFoundException) {
      e.printStackTrace()
      Toast.makeText(context, "您的手机没有安装应用商店($marketPackageName)", Toast.LENGTH_SHORT).show()
    }
  }


  /**
   * 获取已安装应用商店的包名列表
   */
  fun getInstallMarket(context: Context, packages: List<String>?): List<String> {
    val pkgs = ArrayList<String>()

    packages?.also {
      for (i in it.indices) {
        if (isPackageExist(context, it[i])) {
          pkgs.add(it[i])
        }
      }
    }

    return pkgs
  }

  /**
   * 是否存在当前应用市场
   *
   */
  fun isPackageExist(context: Context, packageName: String?): Boolean {
    val manager = context.packageManager
    val intent = Intent().setPackage(packageName)
    val infos = manager.queryIntentActivities(intent,  PackageManager.GET_RESOLVED_FILTER)
    return infos.size >= 1
  }


  /**
   * 安装app，android 7.0及以上和以下方式不同
   */
  private fun startInstall(context: Context, path: String) {
    val file = File(path)

    if (!file.exists()) {
      return
    }

    val intent = Intent(Intent.ACTION_VIEW)

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      //7.0及以上
      val contentUri = FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file)
      intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
      intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      intent.setDataAndType(contentUri, "application/vnd.android.package-archive")
      context.startActivity(intent)
    } else {
      //7.0以下
      intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive")
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      context.startActivity(intent)
    }
  }
}
