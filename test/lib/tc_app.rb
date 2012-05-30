require 'rubygems'
require 'sinatra'
require 'rufus/tokyo'
require 'rack-flash'
require File.join(File.dirname(__FILE__), '../../lib/sinatra-authentication')

use Rack::Session::Cookie, :secret => "heyhihello"
use Rack::Flash
TcUserTable.cabinet_path = File.dirname(__FILE__)

set :environment, 'development'
set :public, 'public'
set :views,  'views'

get '/' do
  send TEMPLATE, "= render_login_logout", :layout => :layout
end
