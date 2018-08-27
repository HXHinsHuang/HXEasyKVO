Pod::Spec.new do |s|
  s.name         = "HXEasyKVO"
  s.version      = "1.0.6"
  s.license      = "MIT"
  s.summary      = "Easy to use KVO in Obj-C by Block or SEL."
  s.homepage     = "https://github.com/HXHinsHuang/HXEasyKVO"
  s.source       = { :git => "https://github.com/HXHinsHuang/HXEasyKVO.git", :tag => "#{s.version}" }
  s.source_files = "HXEasyKVO/*.{h,m}"
  s.requires_arc = true
  s.platform     = :ios, "7.0"
  s.frameworks   = "Foundation"
  s.author             = { "haoxian" => "505608099@qq.com" }
  s.social_media_url   = "https://www.jianshu.com/users/328f5f9d0b58/timeline"
end