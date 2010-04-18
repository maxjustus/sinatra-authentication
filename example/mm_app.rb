require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'mongo_mapper'
require 'sinatra-authentication'

logger = Logger.new($stdout)
MongoMapper.connection = Mongo::Connection.new('db.mongohq.com', 27017, :logger => logger)
MongoMapper.database = "fdbk"
MongoMapper.database.authenticate(ENV['mongohq_user'], ENV['mongohq_pass'])

class TestApp < Sinatra::Base
  use Rack::Session::Cookie, :secret => "heyhihello"

  set :environment, 'development'
  set :public, 'public'
  set :views,  'views'

  get '/' do
    haml "= render_login_logout", :layout => :layout
  end
end
