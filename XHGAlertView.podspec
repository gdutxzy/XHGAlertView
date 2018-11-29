#
# Be sure to run `pod lib lint XHGAlertView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XHGAlertView'
  s.version          = '1.1.2'
  s.summary          = 'AlertView，for XHG, supports Custom view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'XHGAlertView ，小黄狗自定义的AlertView样式弹窗，支持整个弹窗完全由自己绘制，也支持将自己自定义的视图加入到默认的样式中。自定义视图支持包含UITextView/UITextField，能保证输入源不会被键盘遮挡'
  
                       DESC

  s.homepage         = 'https://github.com/gdutxzy/XHGAlertView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gdutxzy' => 'xiezongyuan@xhg.com' }
  s.source           = { :git => 'https://github.com/gdutxzy/XHGAlertView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'XHGAlertView/Classes/UIButton+TouchUpInsideBlock.{h,m}', 'XHGAlertView/Classes/XHGAlertView.{h,m}'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Masonry'
  
  
  # s.default_subspec = ''
  
  # s.subspec 'customizeMenuView' do |cmv|
      #cmv.framework = 'UIKit'
      # cmv.dependency 'Masonry'
      # cmv.source_files = 'XHGAlertView/Classes/XHGAlertMenusView.{h,m}', 'XHGAlertView/Classes/XHGTextView.{h,m}'
      #   cmv.resource_bundles = {
      #      'XHGAlertView' => ['XHGAlertView/Assets/*.png']
          #   }
          #end
  
end
