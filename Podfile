# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

target 'Liftracker' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Liftracker
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'SwiftyBeaver'
  pod 'Charts'
  pod 'Alamofire', '~> 4.3'
  pod 'Runes'
  pod 'Curry'
  pod 'PromiseKit', '~> 4.1'
  # pod 'Eureka'

  target 'LiftrackerTests' do
    inherit! :search_paths
    # Pods for testing
    use_frameworks!
    pod 'Alamofire', '~> 4.3'
    pod 'OHHTTPStubs' # Default subspecs, including support for NSURLSession & JSON etc
    pod 'OHHTTPStubs/Swift'
    pod 'Runes'
    pod 'Curry'
    pod 'PromiseKit', '~> 4.1'
    
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
