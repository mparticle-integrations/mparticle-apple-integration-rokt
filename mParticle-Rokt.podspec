Pod::Spec.new do |s|
    s.name             = "mParticle-Rokt"
    s.version          = "8.3.3"
    s.summary          = "Rokt integration for mParticle"

    s.description      = <<-DESC
                       This is the Rokt integration for mParticle.
                       DESC

    s.homepage         = "https://www.mparticle.com"
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { "mParticle" => "support@mparticle.com" }
    s.source           = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-rokt.git", :tag => "v" + s.version.to_s }
    s.social_media_url = "https://twitter.com/mparticle"
    s.swift_version    = '5.3'

    s.ios.deployment_target = "12.0"
    
    # Objective-C subspec
    s.subspec 'ObjC' do |objc|
        objc.source_files = 'mParticle-Rokt/*.{h,m}'
        objc.public_header_files = 'mParticle-Rokt/*.h'
        objc.dependency 'mParticle-Apple-SDK', '~> 8.0'
        objc.dependency 'Rokt-Widget', '~> 4.16'
    end
    
     # Swift subspec
    s.subspec 'Swift' do |swift|
        swift.source_files = 'mParticle-Rokt-Swift/*.swift'
        swift.dependency 'mParticle-Rokt/ObjC'
        swift.dependency 'mParticle-Apple-SDK', '~> 8.0'
        swift.dependency 'Rokt-Widget', '~> 4.16'
    end
    
    # Default includes both
    s.default_subspecs = 'ObjC', 'Swift'
end
