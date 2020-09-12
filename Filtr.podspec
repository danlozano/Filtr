Pod::Spec.new do |s|
  s.name         = "Filtr"
  s.version      = "0.1.2"
  s.summary      = "Swift framework for photo filter effects on iOS/macOS/tvOS."
  s.description  = <<-DESC
  Photo effects framework based on Core Image, using 3D LUT images to create filter effects.
                   DESC
  s.homepage     = "http://github.com/danlozano/Filtr"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Daniel Lozano" => "dan@danielozano.com" }
  s.social_media_url   = "http://twitter.com/danlozanov"

  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"

  s.source       = { :git => "https://github.com/danlozano/Filtr.git", :tag => "#{s.version}" }
  s.source_files = "Filtr/Classes/**/*"
  s.public_header_files = "Filtr/Classes/**/*.h"
  s.resources = "Filtr/Resources/**/*{xcassets,png,fcube}"

end
