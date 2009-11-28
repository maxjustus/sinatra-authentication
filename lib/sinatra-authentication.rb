require 'sinatra/base'
require 'pathname'
require Pathname(__FILE__).dirname.expand_path + "models/abstract_user"

module SinatraAuthentication
  VERSION = "0.0.3"
end

module Sinatra
  module LilAuthentication
    def self.registered(app)
      #INVESTIGATE
      #the possibility of sinatra having an array of view_paths to load from
      #PROBLEM
      #sinatra 9.1.1 doesn't have multiple view capability anywhere
      #so to get around I have to do it totally manually by
      #loading the view from this path into a string and rendering it
      set :lil_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/"

      #TODO write captain sinatra developer man and inform him that the documentation
      #concerning the writing of extensions is somewhat outdaded/incorrect.
      #you do not need to to do self.get/self.post when writing an extension
      #In fact, it doesn't work. You have to use the plain old sinatra DSL

      get '/users' do
        @users = User.all
        if @users != []
          haml get_view_as_string("index.haml"), :layout => use_layout?
        else
          redirect '/signup'
        end
      end

      get '/users/:id' do
        login_required

        @user = User.get(:id => params[:id])
        haml get_view_as_string("show.haml"), :layout => use_layout?
      end

      #convenience for ajax but maybe entirely stupid and unnecesary
      get '/logged_in' do
        if session[:user]
          "true"
        else
          "false"
        end
      end

      get '/login' do
        haml get_view_as_string("login.haml"), :layout => use_layout?
      end

      post '/login' do
          if user = User.authenticate(params[:email], params[:password])
            session[:user] = user.id
            if session[:return_to]
              redirect_url = session[:return_to]
              session[:return_to] = false
              redirect redirect_url
            else
              redirect '/'
            end
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
        haml get_view_as_string("signup.haml"), :layout => use_layout?
      end

      post '/signup' do
        @user = User.set(params[:user])
        if @user
          session[:user] = @user.id
          redirect '/'
        else
          session[:flash] = "failure!"
          redirect '/'
        end
      end

      get '/users/:id/edit' do
        login_required
        redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]

        @user = User.get(:id => params[:id])
        haml get_view_as_string("edit.haml"), :layout => use_layout?
      end

      post '/users/:id/edit' do
        login_required
        redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]

        user = User.get(:id => params[:id])
        user_attributes = params[:user]
        if params[:user][:password] == ""
            user_attributes.delete("password")
            user_attributes.delete("password_confirmation")
        end

        if user.update(user_attributes)
          redirect '/'
        else
          session[:notice] = 'whoops, looks like there were some problems with your updates'
          redirect "/users/#{user.id}/edit"
        end
      end

      get '/users/:id/delete' do
        login_required
        redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]

        if User.delete(params[:id])
          session[:flash] = "way to go, you deleted a user"
        else
          session[:flash] = "deletion failed, for whatever reason"
        end
        redirect '/'
      end


      if Sinatra.const_defined?('FacebookObject')
        get '/connect' do
          if fb[:user]
            if current_user.class != GuestUser
              user = current_user
            else
              user = User.get(:fb_uid => fb[:user])
            end

            if user
              if !user.fb_uid || user.fb_uid != fb[:user]
                user.update :fb_uid => fb[:user]
              end
              session[:user] = user.id
            else
              user = User.set!(:fb_uid => fb[:user])
              session[:user] = user.id
            end
          end
          redirect '/'
        end

        get '/receiver' do
          %[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml" >
              <body>
                <script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/XdCommReceiver.js" type="text/javascript"></script>
              </body>
            </html>]
        end
      end
    end
  end

  module Helpers
    def login_required
      #not as efficient as checking the session. but this inits the fb_user if they are logged in
      if current_user.class != GuestUser
        return true
      else
        session[:return_to] = request.fullpath
        redirect '/login'
        return false
      end
    end

    def current_user
      if session[:user]
        User.get(:id => session[:user])
      else
        GuestUser.new
      end
    end

    def logged_in?
      !!session[:user]
    end

    def use_layout?
      !request.xhr?
    end

    #BECAUSE sinatra 9.1.1 can't load views from different paths properly
    def get_view_as_string(filename)
      view = options.lil_authentication_view_path + filename
      data = ""
      f = File.open(view, "r")
      f.each_line do |line|
        data += line
      end
      return data
    end

    def render_login_logout(html_attributes = {:class => ""})
    css_classes = html_attributes.delete(:class)
    parameters = ''
    html_attributes.each_pair do |attribute, value|
      parameters += "#{attribute}=\"#{value}\" "
    end

      result = "<div id='sinatra-authentication-login-logout' >"
      if logged_in?
        logout_parameters = html_attributes
        # a tad janky?
        logout_parameters.delete(:rel)
        result += "<a href='/users/#{current_user.id}/edit' class='#{css_classes} sinatra-authentication-edit' #{parameters}>edit account</a> "
        if Sinatra.const_defined?('FacebookObject')
          if fb[:user]
            result += "<a href='javascript:FB.Connect.logoutAndRedirect(\"/logout\");' class='#{css_classes} sinatra-authentication-logout' #{logout_parameters}>logout</a>"
          else
            result += "<a href='/logout' class='#{css_classes} sinatra-authentication-logout' #{logout_parameters}>logout</a>"
          end
        else
          result += "<a href='/logout' class='#{css_classes} sinatra-authentication-logout' #{logout_parameters}>logout</a>"
        end
      else
        result += "<a href='/signup' class='#{css_classes} sinatra-authentication-signup' #{parameters}>signup</a> "
        result += "<a href='/login' class='#{css_classes} sinatra-authentication-login' #{parameters}>login</a>"
      end

      result += "</div>"
    end

    if Sinatra.const_defined?('FacebookObject')
      def render_facebook_connect_link(text = 'Login using facebook')
          %[<a href="#" onclick="FB.Connect.requireSession(function(){document.location = '/connect';}); return false;" class="fbconnect_login_button FBConnectButton FBConnectButton_Small">
              <span id="RES_ID_fb_login_text" class="FBConnectButton_Text">
                #{text}
              </span>
            </a>]
      end
    end
  end

  register LilAuthentication
end

class GuestUser
  def guest?
    true
  end

  def permission_level
    0
  end

  # current_user.admin? returns false. current_user.has_a_baby? returns false.
  # (which is a bit of an assumption I suppose)
  def method_missing(m, *args)
    return false
  end
end
