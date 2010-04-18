require 'rubygems'
require 'sinatra'
require 'haml'
require 'rufus/tokyo'
require 'sinatra-authentication'

use Rack::Session::Cookie, :secret => "heyhihello"
TcUserTable.cabinet_path = File.dirname(__FILE__)

set :environment, 'development'
set :public, 'public'
set :views,  'views'

get '/' do
  haml "= render_login_logout", :layout => :layout
end
