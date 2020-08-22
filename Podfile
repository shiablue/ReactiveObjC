
use_frameworks!

dynamic_frameworks = ['Quick', 'Nimble']

# Make all the other frameworks into static frameworks by overriding the static_framework? function to return true
pre_install do |installer|
    installer.pod_targets.each do |pod|
        if !dynamic_frameworks.include?(pod.name)
            puts "Overriding the static_framework? method for #{pod.name}"
            def pod.build_as_static_framework?;
                true
            end
        end
    end
end

target 'ReactiveObjCTests-iOS' do
    platform :ios, '9.0'
    pod 'Quick', '~> 3.0.0'
    pod 'Nimble', '~> 8.1.1'
end

target 'ReactiveObjCTests-tvOS' do
    platform :tvos, '9.0'
    pod 'Quick', '~> 3.0.0'
    pod 'Nimble', '~> 8.1.1'
end

target 'ReactiveObjCTests-macOS' do
    platform :osx, '10.11'
    pod 'Quick', '~> 3.0.0'
    pod 'Nimble', '~> 8.1.1'
end