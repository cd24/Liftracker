# Uncomment this line to define a global platform for your project
platform :ios, '10.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Liftracker' do
  inherit! :search_paths
  pod 'Charts', '~>3.2.2'
  pod 'XLForm', '~> 3.0'
  pod 'Eureka', '~>4.3.1'
  pod 'Bond', '~>7.2.1'
  pod 'RealmSwift', '~>3.13.1'
  pod 'PromiseKit', '~>6.8.3'
  pod 'Runes', '~>4.1.0'
  pod 'Swiftz', '~>0.6.3'
  pod 'Curry'
  abstract_target 'Tests' do
    target "LiftrackerTests"
    target "LiftrackerUITests"
    target "LiftrackerLongTests"

    pod 'Quick', '~>2.0.0'
    pod 'Nimble', '~>8.0.1'
    pod 'SwiftCheck'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
