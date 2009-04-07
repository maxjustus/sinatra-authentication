require 'sinatra/base'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require Pathname(__FILE__).dirname.expand_path + "models/user"

module SinatraAuthentication
  VERSION = "0.0.1"
end

module Sinatra
  module LilAuthentication
    def self.registered(app)
      #INVESTIGATE
      #the possibility of sinatra having an array of view_paths to load from
      #PROBLEM
      #sinatra 9.1.1 doesn't have multiple view capability anywhere
      #so to get around I have to do it totally manually by
      #loading the view into a string and rendering it
      set :lil_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/"

      use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

      #TODO write captain sinatra developer man and inform him that the documentation
      #conserning the writing of extensions is somewhat outdaded/incorrect
      #you do not need to to do self.get/self.post when writing an extension
      #In fact, it doesn't work. You have to use the plain old sinatra DSL

      get '/users' do
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
        erb get_view_as_string("login.erb")
      end

      post '/login' do
          if user = User.authenticate(params[:email], params[:password])
            session[:user] = user.id
            redirect '/'
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
        erb get_view_as_string("signup.erb")
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

      get '/user/:id/delete' do
        user = User.first(params[:id])
        user.delete
        session[:flash] = "way to go, you deleted a user"
        redirect '/'
      end
    end


  end

  module Helpers
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

    #BECAUSE sinatra 9.1.1 can't load views from different paths
    def get_view_as_string(filename)
      view = options.lil_authentication_view_path + filename
      data = ""
      f = File.open(view, "r")
      f.each_line do |line|
        data += line
      end
      return data
    end
  end

  register LilAuthentication
end
