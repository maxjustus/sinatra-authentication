require 'rubygems'
require 'sinatra'
require 'haml'
require 'dm-core'
require 'rack-flash'
require File.join(File.dirname(__FILE__), '../../lib/sinatra-authentication')


class DmUser
  property :name, String
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
DataMapper.auto_migrate!

set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "extend_views/"
use Rack::Session::Cookie, :secret => "heyhihello"
use Rack::Flash

set :environment, 'development'
set :public, 'public'
set :views,  'views'

get '/' do
  puts User.all(:name => 'max')
  haml "= render_login_logout", :layout => :layout
end
