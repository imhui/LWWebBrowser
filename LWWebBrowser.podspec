Pod::Spec.new do |s|

  s.name         = "LWWebBrowser"
  s.version      = "1.0"
  s.summary      = "A web browser control for iOS apps."
  s.homepage     = "https://github.com/imhui/LWWebBrowser"
  s.license      = 'MIT'
  s.author             = { "imhui" => "seasonlyh@gmail.com" }
  s.platform     = :ios
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/imhui/LWWebBrowser.git", :tag => "1.0" }
  s.source_files  = 'LWWebBrowser/LWWebBrowser/*.{h,m}'
  s.resource  = "LWWebBrowser/LWWebBrowser/LWWebBrowser.bundle"
  s.requires_arc = true

end
