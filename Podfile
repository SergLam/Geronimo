
platform :ios, '11.0'
deployment_target = '11.0'

install! 'cocoapods', :disable_input_output_paths => true, :warn_for_unused_master_specs_repo => false

use_frameworks!
inhibit_all_warnings!

def all_pods
  
  # UI
  pod 'SnapKit', '~> 5.0.1'
  pod 'Charts', '~> 3.6.0'
  
  # Database
  pod 'RealmSwift', '~> 10.7.4'
  
  # Code-generation
  pod 'R.swift', '~> 5.4.0'
  
  # Code-style
  pod 'SwiftLint', '~> 0.43.1'
  
end

abstract_target 'App' do

  target 'Geronimo' do
    inhibit_all_warnings!
    all_pods
  end
  
  post_install do |installer|
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO' # set 'NO' to disable DSYM uploading - usefull for third-party error logging SDK (like Firebase)
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
    end
    
    installer.generated_projects.each do |project|
      project.build_configurations.each do |bc|
        bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
      end
    end
    
  end
  
end


