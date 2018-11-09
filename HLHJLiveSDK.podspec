


Pod::Spec.new do |s|

  s.name         = "HLHJLiveSDK"
  s.version      = "1.0.5"

  s.summary      = "答题答题答题答题"
  s.description  = <<-DESC
                   "答题答题答题答题"
                   DESC

  s.platform =   :ios, "9.0"
  s.ios.deployment_target = "9.0"

  s.homepage     = "https://github.com/zaijianrumo/HLHJLiveSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zaijianrumo" => "2245190733@qq.com" }
  s.source       = { :git => "https://github.com/zaijianrumo/HLHJLiveSDK.git", :tag =>  s.version}
  s.xcconfig = {'VALID_ARCHS' => 'arm64 x86_64'}

  s.source_files            = "HLHJFramework/HLHJLiveSDK.framework/Headers/*.{h,m}" 
  s.ios.vendored_frameworks = "HLHJFramework/HLHJLiveSDK.framework","HLHJFramework/IJKMediaFramework.framework"
  s.resources               = "HLHJFramework/HLHJNewLiveResource.bundle","HLHJFramework/HLHJLiveImgs.bundle"

  s.frameworks = 'VideoToolbox','UIKit','QuartzCore','OpenGLES','MobileCoreServices','MediaPlayer','CoreVideo','CoreMedia','CoreGraphics','AVFoundation','AudioToolbox'

  s.dependency            "AFNetworking"
  s.dependency            "BarrageRenderer"
  s.dependency            "MBProgressHUD"
  s.dependency            "MJRefresh"
  s.dependency            "Masonry"
  s.dependency            "SDWebImage"
  s.dependency            "UMengAnalytics-NO-IDFA"
  s.dependency            "Masonry"
  s.dependency            "WMPageController"
  s.dependency            "YYModel"
  s.dependency            "TMUserCenter"



end
