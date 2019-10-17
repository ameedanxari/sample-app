# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Tribe' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tribe
  pod 'CHIPageControl', '~> 0.1.7'
  pod 'RangeSeekSlider', '~> 1.8.0'
  pod 'DLRadioButton', '~> 1.4'
  pod 'EasyTipView', '~> 2.0.4'
  pod 'IQKeyboardManager', '~> 5.0.8'
  pod 'Firebase/Core', '~> 4.0'
  pod 'Firebase/Database', '~> 4.1'
  pod 'Firebase/Auth', '~> 4.4'
  pod 'Firebase/Storage'
#  pod 'Firebase/Crash'
  pod 'Firebase/Messaging'
  pod 'Fabric', '~> 1.7.7'
  pod 'Crashlytics', '~> 3.10.3'
  pod 'Alamofire', '~> 4.7.2'
  pod 'DatePickerDialog'
  pod 'FacebookCore'#, '~> 0.3.0'
  pod 'FacebookLogin'#, '~> 0.3.0'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'JHTAlertController', '~> 0.2.4'
  pod 'SDWebImage/WebP', '~> 4.3.3'
  pod 'JSQMessagesViewController'
  pod 'TOCropViewController', '~> 2.3.6'
  pod 'GooglePlaces', '~> 2.6.0'
  pod 'MMSProfileImagePicker'
  pod 'RMDateSelectionViewController', '~> 2.3.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
    
    if ['JHTAlertController'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
