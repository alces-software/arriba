$:.push File.expand_path("../lib", __FILE__)
require 'arriba/version'

Gem::Specification.new do |s|
  s.name = 'arriba'
  s.version = Arriba::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = "2013-02-14"
  s.authors = ['Mark J. Titorenko']
  s.email = 'mark.titorenko@alces-software.com'
  s.homepage = 'http://github.com/mjtko/arriba'
  s.summary = %Q{Arriba provides a ruby backend for the ElFinder 2.x API}
  s.description = %Q{Arriba provides a ruby backend for the ElFinder JavaScript file browser 2.x API}
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.rdoc',
  ]

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.7')
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  if File.exist?(File.join(File.dirname(__FILE__),'.git'))  
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  end
  s.require_paths = ['lib']

  s.add_dependency 'activesupport'
  s.add_development_dependency 'geminabox'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'bueller'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rcov'
end

