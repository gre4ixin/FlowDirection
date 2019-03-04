
Pod::Spec.new do |spec|

  spec.name         = "FlowDirection"
  spec.version      = "0.0.5"
  spec.summary      = "App router"
  spec.description  = "coordinate navigation"

  spec.homepage     = "https://github.com/gre4ixin/FlowDirection"

  spec.license = { :type => "MIT", :file => "LICENSE" }

  spec.author  = { "Pavel" => "pav.gre4ixin@yandex.ru" }

  spec.platform     = :ios
  spec.platform     = :ios, "9.1"

  spec.source       = { :git => "https://github.com/gre4ixin/FlowDirection.git", :tag => "#{spec.version}" } # set git

  spec.source_files  = 'Source/*.swift'

  spec.framework  = "UIKit"
  spec.dependency "RxSwift", "~> 4.4.1"
  spec.dependency "RxCocoa", "~> 4.4.1"
  spec.swift_version = "4.2"

end
