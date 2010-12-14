# Allows you to use the models from cron scripts etc
if !Object.const_defined?("Sinatra")
  class Sinatra;end # To please the testing for Sinatra.const_defined?('FacebookObject')
  require File.expand_path(File.join(__FILE__,'../../models/') + 'abstract_user.rb')
end