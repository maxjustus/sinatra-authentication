require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  
  Jeweler::Tasks.new do |gemspec|
    gemspec.name           = 'sinatra-authentication'
    gemspec.version        = '0.0.5'
    gemspec.description    = "Simple authentication plugin for sinatra."
    gemspec.summary        = "Simple authentication plugin for sinatra."
    gemspec.homepage       = "http://github.com/maxjustus/sinatra-authentication"
    gemspec.author         = "Max Justus Spransy"
    gemspec.email          = "maxjustus@gmail.com"
    gemspec.add_dependency "sinatra"
    gemspec.add_dependency "dm-core"
    gemspec.add_dependency "dm-validations"
    gemspec.add_dependency "dm-timestamps"
    gemspec.add_dependency "rufus-tokyo"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it first!"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
