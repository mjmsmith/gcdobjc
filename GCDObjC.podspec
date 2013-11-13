Pod::Spec.new do |s|

  s.name         = "GCDObjC"
  s.version      = "0.1.0"
  s.summary      = "Objective-C wrapper for Grand Central Dispatch."

  s.description  = <<-DESC
                   Objective-C classes wrapping GCD queue, semaphore, and group functions.
                   Detailed HeaderDoc comments for all methods.
                   DESC

  s.homepage     = "https://github.com/mjmsmith/gcdobjc"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Mark Smith" => "mark@camazotz.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/mjmsmith/gcdobjc.git", :tag => "v0.1.0" }
  s.source_files  = 'GCDObjC'
  s.requires_arc = true
end
