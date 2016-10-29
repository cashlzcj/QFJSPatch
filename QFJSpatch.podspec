Pod::Spec.new do |s|
  s.name         = "QFJSpatch"
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
  s.source       = { :git => "https://github.com/cashlzcj/QFJSPatch.git", :tag => "1.0.0" }
  s.source_files  = "Classes", "QFJSPatch/Classes/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.public_header_files = "QFJSPatch/Classes/*.h"
  s.requires_arc = true


end
