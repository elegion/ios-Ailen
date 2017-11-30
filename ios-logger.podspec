Pod::Spec.new do |s|
  s.name                    = 'ios-logger'
  s.version                 = '1.0.0.alpha.1'
  s.summary                 = 'iOS logger'
  s.description             = 'Flexible debug logger for your iOS applications'
  s.homepage                = 'https://gitlab.e-legion.com/e-legion-ios/ios-logger'
  s.license                 = 'MIT'  
  s.authors                 = { "e-Legion Ltd." => "evgeniy.akhmerov@e-legion.com" }

  s.source                  = { :git => 'https://gitlab.e-legion.com/e-legion-ios/ios-logger.git', :branch => "development" }

  s.ios.deployment_target   = '9.0'
  s.requires_arc            = true

  s.source_files            = 'Source'
  s.resource_bundles = {
    'ios-logger' => ['Resources/*.{xcdatamodeld}']
  }

  s.frameworks              = 'Foundation', 'CoreData'
end
