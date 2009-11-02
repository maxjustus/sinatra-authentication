require 'rubygems'
require 'rake'
require 'jeweler'

#Echoe.new('sinatra-authentication', '0.0.5') do |p|
#  p.description    = "Simple authentication plugin for sinatra."
#  p.url            = "http://github.com/maxjustus/sinatra-authentication"
#  p.author         = "Max Justus Spransy"
#  p.email          = "maxjustus@gmail.com"
#  p.ignore_pattern = []
#  p.development_dependencies = ["sinatra", "dm-core", "dm-timestamps", "dm-validations", "rufus-tokyo"]
#end

Jeweler::Tasks.new do |gemspec|
  gemspec.name           = 'sinatra-authentication'
  gemspec.version        = '0.0.5'
  gemspec.description    = "Simple authentication plugin for sinatra."
  gemspec.summary    = "Simple authentication plugin for sinatra."
  gemspec.homepage       = "http://github.com/maxjustus/sinatra-authentication"
  gemspec.author         = "Max Justus Spransy"
  gemspec.email          = "maxjustus@gmail.com"
  #gemspec.dependencies = ["sinatra", "dm-core", "dm-timestamps", "dm-validations", "rufus-tokyo"]
  gemspec.add_dependency "sinatra"
  gemspec.add_dependency "dm-core"
  gemspec.add_dependency "dm-timestamgemspecs"
  gemspec.add_dependency "dm-validations"
  gemspec.add_dependency "rufus-tokyo"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
