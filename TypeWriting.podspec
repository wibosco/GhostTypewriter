Pod::Spec.new do |s|

  s.name         = "TypeWriting"
  s.version      = "0.0.1"
  s.summary      = "A UILabel subclass that adds a type writing animation effect."

  s.homepage     = "http://www.williamboles.me"
  s.license      = { :type => 'MIT', 
  					 :file => 'LICENSE.md' }
  s.author       = "William Boles"

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/wibosco/TypeWritingLabel.git", 
  					 :branch => "master", 
  					 :tag => s.version }

  s.source_files  = "TypeWriting/**/*.swift"
	
  s.requires_arc = true

  s.frameworks = 'UIKit'
  
end
