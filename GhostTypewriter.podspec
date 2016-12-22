Pod::Spec.new do |s|

  s.name         = "GhostTypewriter"
  s.version      = "0.5.1"
  s.summary      = "A UILabel subclass that adds a type writing animation effect."

  s.homepage     = "http://www.williamboles.me"
  s.license      = { :type => 'MIT', 
  					 :file => 'LICENSE.md' }
  s.author       = "William Boles"

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/wibosco/GhostTypewriter.git", 
  					 :branch => "master", 
  					 :tag => s.version }

  s.source_files  = "GhostTypewriter/**/*.swift"
	
  s.requires_arc = true

  s.frameworks = 'UIKit'
  
end
