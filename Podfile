source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
target 'CTwitter' do
	use_frameworks!

	# Twitter framework for ios
	pod 'TwitterKit'

	# Third party libs
	pod 'Alamofire'
	pod 'AlamofireImage'
end

post_install do |installer|
	installer.aggregate_targets.each do |aggregate_target|
		aggregate_target.xcconfigs.each do |config_name, config_file|
			config_file.other_linker_flags[:frameworks].delete("TwitterCore")
			
			xcconfig_path = aggregate_target.xcconfig_path(config_name)
			config_file.save_as(xcconfig_path)
		end
	end
end
