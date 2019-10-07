source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def commom_pods
    pod 'SwiftLint'
end

def testing_pods
    pod 'Quick'
    pod 'Nimble'
end

target 'Bauhaus iOS' do
    platform :ios, '10.0'
    commom_pods

    target 'BauhausiOSTests' do
        testing_pods
    end
    
    target 'BauhausiOSUITests' do
        testing_pods
    end
end

target 'Bauhaus tvOS' do
    platform :tvos, '10.0'
    commom_pods

    target 'BauhaustvOSTests' do
        inherit! :search_paths
        testing_pods
    end
    
    target 'BauhaustvOSUITests' do
        inherit! :search_paths
        testing_pods
    end
end

target 'Bauhaus macOS' do
    platform :osx, '10.10'
    commom_pods

    target 'BauhausmacOSTests' do
        inherit! :search_paths
        testing_pods
    end
    
    target 'BauhausmacOSUITests' do
        inherit! :search_paths
        testing_pods
    end
end
