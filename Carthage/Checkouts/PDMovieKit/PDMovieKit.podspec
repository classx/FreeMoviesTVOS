Pod::Spec.new do |spec|
  spec.name = 'PDMovieKit'
  spec.version = '1.0.6'
  spec.summary = 'A simple iOS and tvOS library that provides access to hundreds of free public domain movies.'
  spec.homepage = 'https://github.com/p-morris/PDMovieKit'
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { 'Pete Morris' => 'pete@iosfaststart.com' }
  spec.social_media_url = 'https://stackoverflow.com/users/10246061/pete-morris'
  spec.swift_version = '4.2'
  spec.ios.deployment_target = '10.0'
  spec.tvos.deployment_target = '10.0'
  spec.requires_arc = true
  spec.source = { git: 'https://github.com/p-morris/PDMovieKit.git', tag: "#{spec.version}", submodules: true }
  spec.source_files = 'PDMovieKit/*.swift'
  spec.resource = 'PDMovieKit/categories.json'
  spec.test_spec do |test_spec|
    test_spec.requires_app_host = false
    test_spec.source_files = 'PDMovieKitTests/**/*.swift'
  end
end