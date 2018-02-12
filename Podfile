# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

target 'Liftracker' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Liftracker
  pod 'Fabric', '~> 1.6.11'
  pod 'Crashlytics', '~> 3.8.4'
  pod 'SwiftyBeaver', '~>1.2.2'
  # pod 'Charts', '~>3.0'
  pod 'Alamofire', '~> 4.4.0'
  pod 'Runes', '~> 4.0.1'
  pod 'Curry', '~> 3.0.0'
  pod 'PromiseKit', '~> 4.1'
  pod 'Swiftx', '~> 0.5.2'
  pod 'Swiftz', '~> 0.6.3'
  # pod 'Eureka'

  target 'LiftrackerTests' do
    inherit! :search_paths
    # Pods for testing
    use_frameworks!
    pod 'Quick', '~> 1.2.0'
    pod 'Nimble', '~> 7.0.3'
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
