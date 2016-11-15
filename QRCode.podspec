Pod::Spec.new do |s|
  s.name              = "QRCode"
  s.version           = "2.0"
  s.summary           = "A QRCode generator written in Swift."
  s.description       = "Generate QRCodes and customize their appearance."
  s.homepage          = "https://github.com/aschuch/QRCode"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "Alexander Schuch" => "alexander@schuch.me" }
  s.social_media_url  = "http://twitter.com/schuchalexander"
  s.platform          = :ios, "8.0"
  s.source            = { :git => "https://github.com/aschuch/QRCode.git", :tag => s.version }
  s.requires_arc      = true
  s.source_files      = "QRCode/QRCode.swift", "QRCode/UIImageViewExtension.swift", "QRCode/CIColorExtension.swift", "QRCode/CIImageExtension.swift"
end
