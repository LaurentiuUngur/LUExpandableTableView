Pod::Spec.new do |s|
  s.name         = "LUExpandableTableView"
  s.version      = "6.0.0"
  s.summary      = "A subclass of UITableView with expandable and collapsible sections"
  s.description  = "A subclass of UITableView with expandable and collapsible sections that is easy to use and highly customisable"

  s.homepage     = "https://github.com/LaurentiuUngur/LUExpandableTableView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.source       = { :git => "https://github.com/LaurentiuUngur/LUExpandableTableView.git", :tag => "#{s.version}" }
  s.author       = { "Laurentiu Ungur" => "laurentyu1995@gmail.com" }
  
  s.requires_arc = true
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.9'

  s.source_files   = "Sources/*.{swift}"
  s.preserve_paths = "README*"
end
