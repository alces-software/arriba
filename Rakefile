require 'rubygems'

begin
  require 'bundler'
rescue LoadError
  $stderr.puts "You must install bundler - run `gem install bundler`"
end

begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'bueller'
Bueller::Tasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:examples) do |examples|
  examples.rspec_opts = '-Ispec'
end

task :default => :examples

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "alces-gem-base #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

module Alces
  class Tasks < ::Rake::TaskLib
    def initialize
      yield self if block_given?
      define
    end
      
    def define
      namespace :alces do
        task :release do
          sh 'gem inabox'
        end
      end
      
      Rake.application.instance_variable_get('@tasks').delete('release')
      desc "Release to the Alces Geminabox repo."
      task :release => 'alces:release'
    end
  end
end
Alces::Tasks.new
