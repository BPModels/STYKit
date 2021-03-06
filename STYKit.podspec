#
# Be sure to run `pod lib lint STYKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STYKit'
  s.version          = '0.1.7'
  s.summary          = 'Base project kit'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/BPModels/STYKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sam' => '916878440@qq.com' }
  s.source           = { :git => 'https://github.com/BPModels/STYKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '11.0'
  
  s.source_files = 'STYKit/Classes/**/*'
  
  s.resource_bundles = {
    'STYKit' => ['STYKit/Assets/*']
  }
  s.swift_version = '5.0'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # 布局约束（MIT License）
  s.dependency 'SnapKit', '5.0.1'
  # 图片下载器
  s.dependency 'SDWebImage', '5.12.1'
  # JSON转对象（MIT License）
  s.dependency 'ObjectMapper', '3.5.3'
  # 网络请求
  s.dependency 'Alamofire', '5.0.0-rc.2'
  # JSON转对象的配合网络请求（MIT）
  s.dependency 'AlamofireObjectMapper', '6.2.0'
end
