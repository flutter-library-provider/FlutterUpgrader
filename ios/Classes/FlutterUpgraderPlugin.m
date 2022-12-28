#import "FlutterUpgraderPlugin.h"
#if __has_include(<flutter_upgrader/flutter_upgrader-Swift.h>)
#import <flutter_upgrader/flutter_upgrader-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_upgrader-Swift.h"
#endif

@implementation FlutterUpgraderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterUpgraderPlugin registerWithRegistrar:registrar];
}
@end
