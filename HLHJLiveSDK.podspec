


Pod::Spec.new do |s|

  s.name         = "HLHJLiveSDK"
  s.version      = "1.0.2"

  s.summary      = "答题答题答题答题"
  s.description  = <<-DESC
                   "答题答题答题答题"
                   DESC

  s.platform =   :ios, "9.0"
  s.ios.deployment_target = "9.0"

  s.homepage     = "https://github.com/zaijianrumo/HLHJLiveSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zaijianrumo" => "2245190733@qq.com" }
  s.source       = { :git => "https://github.com/zaijianrumo/HLHJLiveSDK.git", :tag => "1.0.2"}
  s.xcconfig = {'VALID_ARCHS' => 'arm64 x86_64'}

  s.source_files            = "HLHJFramework/HLHJLiveSDK.framework/Headers/*.{h}" 
  s.ios.vendored_frameworks = "HLHJFramework/HLHJLiveSDK.framework","HLHJFramework/IJKMediaFramework.framework"
  s.resources               = "HLHJFramework/HLHJNewLiveResource.bundle","HLHJFramework/HLHJLiveImgs.bundle"

  s.frameworks = 'VideoToolbox','UIKit','QuartzCore','OpenGLES','MobileCoreServices','MediaPlayer','CoreVideo','CoreMedia','CoreGraphics','AVFoundation','AudioToolbox','libz','Libbz2'

  s.dependency            "AFNetworking","~>3.2.1"
  s.dependency            "BarrageRenderer","~>2.1.0"
  s.dependency            "MBProgressHUD","~>1.1.0"
  s.dependency            "MJRefresh","~>3.1.15.6"
  s.dependency            "Masonry","~>1.1.0"
  s.dependency            "SDWebImage","~>4.4.2"
  s.dependency            "UMengAnalytics-NO-IDFA","~>4.2.5"
  s.dependency            "Masonry","~>1.1.0"
  s.dependency            "WMPageController","~>2.5.2"
  s.dependency            "YYModel","~>1.0.4"
  s.dependency            "TMUserCenter"


  #s.source_files           = "HLHJLiveSDK/*"


end
