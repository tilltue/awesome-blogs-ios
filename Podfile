platform :ios, '9.1'

source 'https://github.com/CocoaPods/Specs.git'
def test_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'RxTest'
end

target 'AwesomeBlogs' do
    use_frameworks!
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'SwiftyJSON'
    pod 'ObjectMapper'
    pod 'ReactorKit'
    pod 'Moya/RxSwift'
    pod 'XCGLogger'
    pod 'SwiftDate', '~> 4.0'
    pod 'EasyAbout'
    pod 'Down'
    pod 'RealmSwift'
    pod 'KRWordWrapLabel'
    pod 'Swinject', '~> 2.1.0'
    pod 'FAPanels', :git => 'https://github.com/tilltue/FAPanels', :branch => 'master'
    target 'AwesomeBlogsTests' do
        test_pods
    end
    target 'AwesomeBlogsUITests' do
        test_pods
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
