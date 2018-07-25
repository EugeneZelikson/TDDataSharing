Pod::Spec.new do |s|
    s.name             = 'TDDataSharing'
    s.version          = '1.0'
s.summary          = 'If you need to link independent applications, you can use TDDataSharing.'

    s.description      = <<-DESC
    If you need to link independent applications, you can use TDDataSharing. This is an easy way to organize conversations between applications using the URL schemes. This library uses a clipboard and a URL scheme to organize the interaction.
    DESC

    s.homepage         = 'http://topdevs.org'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andrew' => 'andrew@topdevs.org' }
    s.source           = { :git => 'https://github.com/TheTopDevs/TDDataSharing.git', :tag => s.version.to_s }

    s.ios.deployment_target = '10.0'
    s.source_files = 'TDDataSharing/*'
    s.swift_version = '4.1'

end
