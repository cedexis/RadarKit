Pod::Spec.new do |spec|
    spec.name          = "RadarKit"
    spec.version       = "1.2.0"
    spec.summary       = "Citrix ITM Radar Runner for Apple iOS and MacOS."
    spec.homepage      = "https://github.com/cedexis/radarkit"
    spec.author        = { "David Turnbull" => "david.turnbull@citrix.com" }
    spec.source        = { :git => "https://github.com/cedexis/RadarKit.git", :tag => spec.version.to_s }
    spec.frameworks    = ['Foundation', 'WebKit']
    spec.ios.deployment_target = '9.0'
    spec.osx.deployment_target = '10.10'
    spec.swift_version = '5.0'
    spec.default_subspec = 'Swift'
    spec.subspec 'Swift' do |sw|
        sw.source_files  = "RadarKit.swift"
    end
    spec.subspec 'ObjC' do |oc|
        oc.source_files  = "RadarKit.{h,m}"
    end
    spec.license       = { :type => 'MIT', :text => 'The MIT License (MIT)

        Copyright 2018 Citrix Systems, Inc.

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.' }
end
