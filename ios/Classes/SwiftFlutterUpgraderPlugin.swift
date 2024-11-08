import Flutter
import UIKit

public class SwiftFlutterUpgraderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_upgrader", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterUpgraderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getAppInfo") {
      let infoDictionary = Bundle.main.infoDictionary!
      let majorVersion = infoDictionary["CFBundleShortVersionString"]
      let bundleIdentifier = infoDictionary["CFBundleIdentifier"]
      var map = [String:String]()

      map["packageName"] = (bundleIdentifier as? String) ?? ""
      map["versionName"] = (majorVersion as? String) ?? ""
      map["versionCode"] = "0"

      result(map)
    } else if (call.method == "jumpAppStore") {
      let args = call.arguments as! Dictionary<String, String>
      let urlString = args["beta"] == "true" ? "itms-beta://itunes.apple.com/app/" + (args["id"] ?? "") : "itms-apps://itunes.apple.com/app/" + (args["id"] ?? "")

      if let url = URL(string: urlString) {
        if #available(iOS 10, *) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
          UIApplication.shared.openURL(url)
        }
      }
    }
  }
}
