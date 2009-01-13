require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'rack/session/hashed_cookie'
require Pathname(__FILE__).dirname.expand_path + "models/user"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/test.db")
DataMapper.auto_upgrade!

disable :sessions
use Rack::Session::HashedCookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

get '/' do
  login_required
  @users = User.all
  erb "<% @users.each { |user| %>hi <%= user.email %> <br /> <% }%>"
end

get '/logged_in' do
  if session[:user]
    "true"
  else
    "false"
  end
end

get '/login' do
  erb :login
end

post '/login' do
    if user = User.authenticate(params[:email], params[:password])
      session[:user] = user.id
      redirect_to_stored
    else
      redirect '/login'
    end
end

get '/logout' do
  session[:user] = nil
  @message = "in case it weren't obvious, you've logged out"
  redirect '/'
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
  if @user.save
    session[:user] = @user.id
    redirect '/'
  else
    session[:flash] = "failure!"
    redirect '/'
  end
end

delete '/user/:id' do
  user = User.first(params[:id])
  user.delete
  session[:flash] = "way to go, you deleted a user"
  redirect '/'
end

private

def login_required
  if session[:user]
    return true
  else
    session[:return_to] = request.fullpath
    redirect '/login'
    return false 
  end
end

def current_user
  User.first(session[:user])
end

def redirect_to_stored
  if return_to = session[:return_to]
    session[:return_to] = nil
    redirect return_to
  else
    redirect '/'
  end
end
