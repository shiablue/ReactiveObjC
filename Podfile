
use_frameworks!

def testing_pods
  pod 'Quick', :tag => 'v3.0.1', :git => 'https://github.com/cntrump/Quick.git'
  pod 'Nimble', :tag => 'v8.1.2', :git => 'https://github.com/cntrump/Nimble.git'
end

target 'ReactiveObjCTests-iOS' do
    platform :ios, '9.0'
    testing_pods
end

target 'ReactiveObjCTests-tvOS' do
    platform :tvos, '9.0'
    testing_pods
end

target 'ReactiveObjCTests-macOS' do
    platform :osx, '10.11'
    testing_pods
end
