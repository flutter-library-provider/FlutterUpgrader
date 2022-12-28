#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_upgrader.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_upgrader'
  s.version          = '1.0.2'
  s.summary          = 'A Flutter App Upgrader plugin.'
  s.description      = <<-DESC
A Flutter App Upgrader plugin, Support ios and android upgrade from the app store.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
