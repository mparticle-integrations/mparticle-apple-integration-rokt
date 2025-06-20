Pod::Spec.new do |s|
    s.name             = "mParticle-Rokt"
    s.version          = "8.2.0"
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
    s.ios.source_files      = 'mParticle-Rokt/*.{h,m,swift}'
    s.ios.public_header_files = 'mParticle-Rokt/*.h'
    s.ios.dependency 'mParticle-Apple-SDK', '~> 8.0'
    s.ios.dependency 'Rokt-Widget', '~> 4.10'
end
