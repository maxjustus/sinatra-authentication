require 'rubygems'
require 'sinatra'
require 'haml'
require 'sinbook'
require 'dm-core'
require File.join(File.dirname(__FILE__), '../../lib/sinatra-authentication')

facebook do
  api_key 'aa2db1b96cb7b57f0c5b1d4d3d8f0a22'
  secret '21d94ee63969ae3b3f833689838ca00f'
  app_id 48652736613
  url 'peoplewithjetpacks.com:4568/'
  callback 'peoplewithjetpacks.com:4568/'
end

set :port, 4568

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
DataMapper.auto_migrate!

use Rack::Session::Cookie, :secret => "heyhihello"

set :environment, 'development'
set :public, 'public'
set :views,  'views'

get '/' do
  haml :main
end

get '/test' do
  login_required
  'hihihi'
end
 
__END__
 
@@ layout
%html{:xmlns=>"http://www.w3.org/1999/xhtml", :'xmlns:fb'=>"http://www.facebook.com/2008/fbml"}
  %head
    %title Welcome to my Facebook Connect website!
    %script{:type => 'text/javascript', :src => 'http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php/en_US'}
  %body
    = render_login_logout
    = yield
    :javascript
      FB.init("#{fb.api_key}", "/receiver")
 
@@ main
- if fb[:user]
  Hi,
  %fb:profile-pic{:uid => fb[:user]}
  %fb:name{:uid => fb[:user], :useyou => 'false', :firstnameonly => 'true'}
  !
 
