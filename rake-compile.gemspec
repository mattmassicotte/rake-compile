# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name        = 'rake-compile'
  spec.version     = '0.1.0'
  spec.date        = '2013-11-04'
  spec.summary     = 'Rake-compile makes it easier to use rake to build native projects'
  spec.description = 'Rake-compile is a set of rake tasks and utitlies to help build native projects'
  spec.authors     = ['Matt Massicotte']
  spec.files       = Dir.glob('lib/**/*.rb')
  spec.homepage    = 'https://github.com/mattmassicotte/rake-compile'
  spec.license     = 'MIT'

  spec.add_runtime_dependency 'colorize'
end
