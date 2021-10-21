#
# Be sure to run `pod lib lint base.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SociomileChatSDK'
  s.version          = '1.0.0'
  s.summary          = 'Sociomile Chat SDK'

  s.description      = 'Sociomile Chat SDK for chat , this is a framework for App'

  s.homepage         = 'https://github.com/HarioBudiharjo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'MIT (iOS)'
  s.author           = { 'Hario Budiharjo' => 'hariobudiharjo@gmail.com' }
  s.source           = { :git => 'https://hariobudiharjo18@bitbucket.org/tunaiku/tunaiku-ios-version.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.2'

  s.source_files = 'SociomileChatSDK/Modules/**/*.{h,m,swift}'
  
   s.resource_bundles = {
     'SociomileChatSDK' => ['SociomileChatSDK/Assets/**/*.{storyboard,xib,xcassets,json,imageset,png,plist}']
  }

   #s.public_header_files = 'Pod/Classes/**/*.h'
  #  s.dependency 'TunaikuCommon'

end
