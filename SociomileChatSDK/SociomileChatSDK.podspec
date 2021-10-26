Pod::Spec.new do |s|
  s.name             = 'SociomileChatSDK'
  s.version          = '1.0.0'
  s.summary          = 'Sociomile Chat SDK'

  s.description      = 'Sociomile Chat SDK for chat , this is a framework for App'

  s.homepage         = 'https://github.com/HarioBudiharjo'
  s.license          = 'MIT (iOS)'
  s.author           = { 'Hario Budiharjo' => 'hariobudiharjo@gmail.com' }
  s.source           = { :git => 'https://github.com/HarioBudiharjo/Sociomile-Chat-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.2'

  s.source_files = 'SociomileChatSDK/Modules/**/*.{h,m,swift}'
  
   s.resource_bundles = {
     'SociomileChatSDK' => ['SociomileChatSDK/Assets/**/*.{storyboard,xib,xcassets,json,imageset,png,plist}']
  }
  
  s.dependency 'Alamofire', '~> 5.4'
  s.dependency 'Kingfisher', '~> 7.0'
  s.dependency 'Socket.IO-Client-Swift', '~> 15.2.0'

end
