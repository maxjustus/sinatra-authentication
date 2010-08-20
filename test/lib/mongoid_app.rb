require 'rubygems'
require 'sinatra'
require 'haml'
require 'rack-flash'
require 'mongoid'

#logger = Logger.new($stdout)
#MongoMapper.connection = Mongo::Connection.new('db.mongohq.com', 27017, :logger => logger)
#MongoMapper.database = "fdbk"
#MongoMapper.database.authenticate(ENV['mongohq_user'], ENV['mongohq_pass'])

require File.join(File.dirname(__FILE__), '../../lib/sinatra-authentication')

Mongoid.configure do |config|
  name = "sinatraauth_test"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
end

use Rack::Session::Cookie, :secret => "heyhihello"
use Rack::Flash

set :environment, 'development'
set :public, 'public'
set :views,  'views'

get '/' do
  haml "= render_login_logout", :layout => :layout
end
