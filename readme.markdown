### a little sinatra gem that implements user authentication, with support for both datamapper and rufus-tokyo

## INSTALLATION:

in your sinatra app simply require either "dm-core" or "rufus-tokyo" and then "sinatra-authentication" and turn on session storage
with a super secret key, like so:

    require "dm-core"
    require "sinatra-authentication"

    use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

  If you're using rufus-tokyo, you also need to set the database path for Users. like so:

    require "rufus_tokyo"
    require "sinatra-authentication"
    TcUserTable.cabinet_path = File.dirname(__FILE__) + 'folder/where/you/wanna/store/your/database'

    use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

## DEFAULT ROUTES:

* get      '/login'
* get      '/logout'
* get      '/signup'
* get/post '/users'
* get       '/users/:id'
* get/post  '/users/:id/edit'
* get       '/users/:id/delete'

## ADDITIONAL ROUTES WHEN USING SINBOOK FOR FACEBOOK INTEGRATION:

* get      '/reciever'
* get      '/connect'

If you fetch any of the user pages using ajax, they will automatically render without a layout

## HELPER METHODS:

This plugin provides the following helper methods for your sinatra app:

* login_required
  > which you place at the beginning of any routes you want to be protected
* current_user
* logged_in?
* render_login_logout(html_attributes)
  > Which renders login/logout and singup/edit account links.
If you pass a hash of html parameters to render_login_logout all the links will get set to them.
Which useful for if you're using some sort of lightbox

## SIMPLE PERMISSIONS:

By default the user class includes a method called admin? which simply checks
if user.permission_level == -1.

you can take advantage of  this method in your views or controllers by calling
current_user.admin?
i.e.

    - if current_user.admin?
      %a{:href => "/adminey_link_route_thing"} do something adminey

(these view examples are in HAML, by the way)

You can also extend the user class with any convenience methods for determining permissions.
i.e.

    #somewhere in the murky depths of your sinatra app
    class User
      def peasant?
        self.permission_level == 0
      end
    end

then in your views you can do

    - if current_user.peasant?
      %h1 hello peasant!
      %p Welcome to the caste system! It's very depressing.

if no one is logged in, current_user returns a GuestUser instance, which responds to current_user.guest?
with true, current_user.permission_level with 0 and any other method calls with false

This makes some view logic easier since you don't always have to check if the user is logged in,
although a logged_in? helper method is still provided

## RUFUS TOKYO

when using rufus-tokyo, current_user returns a hash, so to get the primary key of the current_user you would do current_user[:pk].
if you wanna set an attribute, you can do something like current_user["has_a_dog"] = true
and if you want to open a connection with the cabinet directly, you can do something like

    user_connection = TcUser.new
    users_with_gmail = user_connection.query do |q|
      q.add 'email', :strinc, 'gmail'
    end
    user_connection.close

## FACEBOOK

# at present, sinatra authentication supports sinbook for interacting with the facebook api.

If you want to allow users to login using facebook, just require 'sinbook' before requiring 'sinatra-authentication'.
The routes '/reciever' and '/connect' will be added. as well as connect links on the login and edit account pages.
You'll still have to include and initialize the facebook connect javascript in your layout yourself, like so:

(This example layout assumes you're using sinbook)

    !!!
      %head
        %title Welcome to my Facebook Connect website!
        %script{:type => 'text/javascript', :src => 'http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php/en_US'}
      %body
        = yield
        :javascript
          FB.init("#{fb.api_key}", "/receiver")

Just remember to specify '/reciever' as the path to the xd-receiver file in your call to 'FB.init'.

The render_login_logout helper 'logout' link will log the user out of facebook and your app.

I've also included a little helper method 'render_facebook_connect_link' for rendering the facebook connect link with the correct 'onconnect' javascript callback.
The callback redirects to '/connect'.
This is important because the way I've implemented facebook connect support is by pinging '/connect' after the user
successfully connects with facebook.

If you choose to render the connect button yourself, be sure to have the 'onconnect' callback include "window.location = '/connect'".

'/connect' redirects to '/' on completion.

The 'render_facebook_connect_link' helper uses html instead of fbml, so ajax requests to '/login' or "/users/#{user.id}/edit"
will render the connect link without you needing to parse any fbml.

If the user is already logged into the app and connects with facebook via the user edit page,
it adds their fb_uid to their profile in the database.
which will allow them to log in using their email and password, OR their facebook account.

If they aren't already logged in to the app through the normal login form,
it creates a new user in the database without an email address or password.
They can later add this data by going to "/users/#{current_user.id}/edit",
which will allow them to log in using their email address and password, OR their facebook account.
