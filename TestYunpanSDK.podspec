Pod::Spec.new do |s|
  s.name             = 'TestYunpanSDK'
  s.version          = '0.0.1'
  s.summary          = 'A short description of TestYunpanSDK.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/ripperhe/TestYunpanSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ripper' => 'ripperhe@qq.com' }
  s.source           = { :git => 'https://github.com/ripperhe/TestYunpanSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'TestYunpanSDK/Classes/**/*'

  # s.resource_bundles = {
  #   'TestYunpanSDK' => ['TestYunpanSDK/Assets/*.png']
  # }

  #s.subspec 'TestYunpanSDK' do | sm |
      #sm.source_files = 'TestYunpanSDK/ZYSubModule/**/*'
      #sm.dependency 'AFNetworking', '~> 2.3'
  #end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
