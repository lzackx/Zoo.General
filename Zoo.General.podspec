#
# Be sure to run `pod lib lint Zoo.General.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Zoo.General'
  s.version          = '1.0.0'
  s.summary          = 'General plugin for Zoo'
  s.description      = <<-DESC
  General plugin for Zoo
                       DESC

  s.homepage         = 'https://github.com/lzackx/Zoo.General'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lzackx' => 'lzackx@lzackx.com' }
  s.source           = { :git => 'https://github.com/lzackx/Zoo.General.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.module_name = 'ZooGeneral'
#  s.pod_target_xcconfig = {
#    'DEFINES_MODULE' => 'YES'
#  }
  s.source_files = 'Zoo.General/Classes/**/*'
  s.dependency 'Zoo'

end
