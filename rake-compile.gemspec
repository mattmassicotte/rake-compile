# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake-compile/version'

Gem::Specification.new do |spec|
  spec.name          = 'rake-compile'
  spec.version       = RakeCompile::VERSION
  spec.authors       = ['Matt Massicotte']

  spec.summary       = 'Rake-compile makes it easier to use rake to build C/C++ projects'
  spec.description   = 'Rake-compile is a set of Rake DSL extensions to help build C/C++ projects'
  spec.homepage      = 'https://github.com/mattmassicotte/rake-compile'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rake', '~> 10.0'
  spec.add_dependency 'rake-multifile'
  spec.add_runtime_dependency 'colorize'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'minitest'
end
