Pod::Spec.new do |s|
  s.name         = "QFJSPatch"
  s.version      = "1.0.0"
  s.summary      = "iOS客户端实现, 配合服务端使用"
  s.description  = <<-DESC
                     JSPatch客户端实现,配合jspatch服务端实现使用
                   DESC

  s.homepage     = "https://github.com/cashlzcj/QFJSPatch"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "junge" => "cashlzcj@gmail.com" }

  s.platform     = :ios
  s.source       = { :git => "https://github.com/cashlzcj/QFJSPatch.git", :tag => s.version }
  s.requires_arc = true
  s.frameworks   = "Foundation"
  s.dependency "JSPatch", "~> 1.0"
  s.dependency "CocoaSecurity", "~> 1.2.4"


  s.subspec 'Core' do |ss|
    ss.ios.source_files = "QFJSPatch/*.{h,m}"
    ss.public_header_files = "QFJSPatch/*.h"
  end

end
