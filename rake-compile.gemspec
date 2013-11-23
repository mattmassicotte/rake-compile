# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name        = 'rake-compile'
  spec.version     = '0.1.1'
  spec.date        = '2013-11-04'
  spec.summary     = 'Rake-compile makes it easier to use rake to build C/C++ projects'
  spec.description = 'Rake-compile is a set of Rake DSL extensions to help build C/C++ projects'
  spec.authors     = ['Matt Massicotte']
  spec.files       = Dir.glob('lib/**/*.rb')
  spec.homepage    = 'https://github.com/mattmassicotte/rake-compile'
  spec.license     = 'MIT'

  spec.add_runtime_dependency 'colorize'
end
