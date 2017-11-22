#
# Be sure to run `pod lib lint MFBValidator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFBValidator'
  s.version          = '0.1.1'
  s.summary          = 'A polymorphic validation toolset for Objective-C'

  s.description      = <<-DESC
MFBValidator allows you to constract a validator object for validating instances of different classes respectively to their class hierarchy.
                       DESC

  s.homepage         = 'https://github.com/flix-tech/MFBValidator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nickolay Tarbayev' => 'tarbayev-n@yandex.ru' }
  s.source           = { :git => 'https://github.com/flix-tech/MFBValidator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.subspec 'Core' do |sp|
    public_header_files = 'MFBValidator/Public/**/*.h'
    sp.public_header_files = public_header_files
    sp.source_files = 'MFBValidator/Sources/**/*.{h,m}', public_header_files
  end

  s.subspec 'Tests' do |sp|
    sp.dependency 'OCMock'
    sp.source_files = 'MFBValidator/**/*.{h,m}'
    sp.frameworks = 'XCTest'
  end

  s.default_subspec = 'Core'
end
