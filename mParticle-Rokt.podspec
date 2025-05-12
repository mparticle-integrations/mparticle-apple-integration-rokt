Pod::Spec.new do |s|
    s.name             = "mParticle-Rokt"
    s.version          = "8.0.1"
    s.summary          = "Rokt integration for mParticle"

    s.description      = <<-DESC
                       This is the Rokt integration for mParticle.
                       DESC

    s.homepage         = "https://www.mparticle.com"
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { "mParticle" => "support@mparticle.com" }
    s.source           = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-rokt.git", :tag => s.version.to_s }
    s.social_media_url = "https://twitter.com/mparticle"
    s.swift_version    = '5.3'

    s.ios.deployment_target = "11.0"
    s.ios.source_files      = 'mParticle-Rokt/*.{h,m}'
    s.ios.dependency 'mParticle-Apple-SDK', '~> 8.0'
    s.ios.dependency 'Rokt-Widget', '~> 4.8'
end
