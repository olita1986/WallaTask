# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'WallaMarvel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WallaMarvel
  pod 'Kingfisher', '~> 8.3'
  pod 'OHHTTPStubs/Swift', '~> 9.1.0'

  target 'WallaMarvelTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WallaMarvelUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
      end
    end
  end
end
