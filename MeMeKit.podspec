#
#  Be sure to run `pod spec lint MeMeBaseKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MeMeKit"
  spec.version      = "1.0.4"
  spec.summary      = "MeMe Modules"

  spec.description  = <<-DESC
                   MeMe Modules,contain,
                   1.UtilView: UI UtilView
                   2.UtilKit: base Kit
                   3....
                   DESC

  spec.homepage     = "https://bitbucket.org/funplus/stlsreaming-client-compents"

  spec.license      = "MIT"
#  spec.license      = { :type => "MIT", :file => "LICENSE.md" }

  spec.author             = { "xfb" => "fabo.xie@nextentertain.com" }

  # spec.platform     = :ios
   spec.platform     = :ios, "10.0"
   spec.ios.deployment_target = "10.0"

  spec.source       = { :git => "https://bitbucket.org/funplus/streaming-client-compents.git",:tag => "#{spec.version}" }

  spec.swift_version = '5.0'

  spec.default_subspec = 'MeMeBaseKit'

  spec.subspec 'Device' do |device|
      device.requires_arc            = true
      device.source_files            = "MeMeBaseKit/Device/Source/*.swift"
      device.ios.source_files        = "MeMeBaseKit/Device/Source/iOS/*.swift"
      device.osx.source_files        = "MeMeBaseKit/Device/Source/macOS/*.swift"
  end
  
  spec.subspec 'SSZipArchive' do |base|
      base.source_files = 'SSZipArchive_2.4.3/SSZipArchive/*.{m,h}', 'SSZipArchive_2.4.3/SSZipArchive/include/*.{m,h}', 'SSZipArchive_2.4.3/SSZipArchive/minizip/*.{c,h}'
      base.public_header_files = 'SSZipArchive_2.4.3/SSZipArchive/*.h'
      base.libraries = 'z', 'iconv'
      base.framework = 'Security'
      base.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES',
    'GCC_PREPROCESSOR_DEFINITIONS' => 'HAVE_INTTYPES_H HAVE_PKCRYPT HAVE_STDINT_H HAVE_WZAES HAVE_ZLIB' }
  end

  spec.subspec 'MeMeBaseKit' do |base|
      base.source_files  = "MeMeBaseKit/MeMeBaseKit/*.{h,m,swift}", "MeMeBaseKit/CommonView/*.swift","MeMeBaseKit/CommonObject/**/*.swift","MeMeBaseKit/OC_CommonObject/**/*.{h,m,c}","MeMeBaseKit/Extensions/*.{h,m,swift}","MeMeBaseKit/NELocalize/*.{h,m,swift}"
      base.exclude_files = "MeMeBaseKit/MeMeBaseKit/MeMeBaseKit.h"

      base.public_header_files = "MeMeBaseKit/MeMeBaseKit/**/*.h", "MeMeBaseKit/OC_CommonObject/**/*.h","MeMeBaseKit/Extensions/**/*.h","MeMeBaseKit/NELocalize/**/*.h"

      # base.resource  = "icon.png"
      base.resources = ["MeMeBaseKit/OC_CommonObject/**/*.bundle",'MeMeBaseKit/Resources/*.bundle']

      # base.preserve_paths = "FilesToSave", "MoreFilesToSave"

      # base.framework  = "SomeFramework"
      # base.frameworks = "SomeFramework", "AnotherFramework"
      base.framework    = "UIKit","Foundation"
      base.dependency 'SwiftyUserDefaults'
      base.dependency 'KeychainAccess'
      base.dependency 'RxSwift'
      base.dependency 'ObjectMapper'
      base.dependency 'YYImage'
      base.dependency 'YYText'
      base.dependency 'YYWebImage'
      base.dependency 'YYImage/WebP'
#      base.dependency 'YYKit'
      base.dependency 'Result'
      base.dependency 'QNNetDiag'
      base.dependency 'MeMeKit/Device'
      base.dependency 'MeMeKit/SSZipArchive'
      base.dependency 'Cartography'

      # base.library   = "iconv"
      base.libraries = "resolv"

      base.requires_arc = true

       base.pod_target_xcconfig = { "GCC_OPTIMIZATION_LEVEL" => 0 , "SWIFT_OPTIMIZATION_LEVEL" => "-Onone","CLANG_CXX_LANGUAGE_STANDARD" => "gnu++0x"}
      # base.dependency "JSONKit", "~> 1.4"
  end

  spec.subspec 'ExView' do |base|
      base.source_files = 'MeMeBaseKit/ExView/**/*.swift'
      base.dependency 'MeMeKit/MeMeBaseKit'
      base.dependency 'Cartography'
      base.dependency 'MBProgressHUD'
      base.framework    = "UIKit"
  end
  
  spec.subspec 'Swizzle' do |base|
      base.source_files = 'MeMeBaseKit/Swizzle/**/*.{h,m}'
      base.dependency 'MeMeKit/MeMeBaseKit'
      base.dependency 'Cartography'
      base.framework    = "UIKit"
      base.requires_arc = false
  end
  
  spec.subspec 'Location' do |base|
      base.source_files = 'MeMeBaseKit/Access/Location/**/*.swift'
      base.dependency 'MeMeKit/MeMeBaseKit'
      base.dependency 'RxSwift'
      base.dependency 'Result'
      base.frameworks    = "Foundation", "CoreLocation"
  end
  
  spec.subspec 'Photo' do |base|
        base.source_files = 'MeMeBaseKit/Access/Photo/**/*.swift'
        base.dependency 'MeMeKit/MeMeBaseKit'
        base.frameworks    = "Foundation", "Photos"
    end
  
  spec.subspec 'Network' do |base|
      base.source_files = 'MeMeBaseKit/Access/Network/**/*.swift'
      base.dependency 'MeMeKit/MeMeBaseKit'
      base.frameworks    = "Foundation", "CoreTelephony"
  end
  
  spec.subspec 'Video' do |base|
      base.source_files = 'MeMeBaseKit/Access/Video/**/*.swift'
      base.dependency 'MeMeKit/MeMeBaseKit'
      base.frameworks    = "Foundation","AVFoundation"
      
      base.dependency 'SwiftyUserDefaults'
  end
  
  spec.subspec 'Audio' do |base|
      base.source_files = 'MeMeBaseKit/Access/Audio/**/*.swift'
      base.dependency 'MeMeKit/MeMeBaseKit'
      base.frameworks    = "Foundation","AVFoundation"
      
      base.dependency 'SwiftyUserDefaults'
  end
  
  spec.subspec 'Photo' do |base|
      base.source_files = 'MeMeBaseKit/Access/Photo/**/*.swift'
      base.dependency 'MeMeKit/MeMeBaseKit'
      base.frameworks    = "Foundation","Photos"
      
      base.dependency 'SwiftyUserDefaults'
  end

end
