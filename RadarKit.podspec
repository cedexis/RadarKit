Pod::Spec.new do |s|
    s.name          = "RadarKit"
    s.version       = "0.1.0"
    s.summary       = "A Cedexis Radar client for iOS."
    s.homepage      = "https://github.com/cedexis/radarkit"
    s.license       = "MIT"
    s.author        = "Jacob Wan"
    s.source        = { :git => "https://github.com/cedexis/RadarKit.git", :tag => s.version.to_s }

    s.platform      = :ios, '7.0'
    s.requires_arc  = true
    s.frameworks    = ['Foundation']

    s.source_files  = "RadarKit/*.{h,m}"
end