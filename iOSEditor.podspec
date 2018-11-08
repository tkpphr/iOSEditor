Pod::Spec.new do |s|
  s.name         = "iOSEditor"
  s.version      = "1.0.0"
  s.summary      = "Editor library for iOS."
  s.homepage     = "https://github.com/tkpphr"
  s.license      = "MIT"
  s.author       = "tkpphr"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/tkpphr/iOSEditor.git", :tag => "#{s.version}" }
  s.source_files  = "iOSEditor/**/*.swift"
  s.resource_bundles = {
    'iOSEditor' => [
    'iOSEditor/**/*.{xib,strings}']
  }
  s.requires_arc = true
end
