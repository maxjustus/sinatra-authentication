require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'rack-flash'
require File.join(File.dirname(__FILE__), '../../lib/sinatra-authentication')

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
DataMapper.auto_migrate!

use Rack::Session::Cookie, :secret => "heyhihello"
use Rack::Flash

set :environment, 'development'
set :public, 'public'
set :views,  'views'

get '/' do
  send TEMPLATE, "= render_login_logout", :layout => :layout
end
