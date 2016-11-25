Pod::Spec.new do |s|
  s.name         = "LUExpandableTableView"
  s.version      = "1.0.1"
  s.summary      = "A subclass of `UITableView` with expandable and collapsible sections"
  s.description  =  "A subclass of `UITableView` with expandable and collapsible sections that is easy to use and highly customisable"

  s.homepage     = "https://github.com/LaurentiuUngur/LUExpandableTableView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.source       = { :git => "https://github.com/LaurentiuUngur/LUExpandableTableView.git", :tag => "#{s.version}" }
  s.author       = { "Laurentiu Ungur" => "laurentyu1995@gmail.com" }
  
  s.requires_arc = true
  s.platform     = :ios, "9.0"
  
  s.source_files   = "LUExpandableTableView/*.{swift}"
  s.preserve_paths = "README*"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
