### A little sinatra gem that implements user authentication, with support for Datamapper, Mongomapper, Mongoid, Sequel and Rufus-Tokyo

## INSTALLATION:

in your sinatra app simply require either "dm-core", 'sequel', 'rufus-tokyo', 'mongoid' or "mongo_mapper", "digest/sha1", 'rack-flash' (if you want flash messages) and then "sinatra-authentication" and turn on session storage
with a super secret key, like so:

    require "dm-core"
    #for using auto_migrate!
    require "dm-migrations"
    require "digest/sha1"
    require 'rack-flash'
    require "sinatra-authentication"

    use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'
    #if you want flash messages
    use Rack::Flash

  If you're using rufus-tokyo, you also need to set the database path for Users. like so:

    require "rufus_tokyo"
    require "digest/sha1"
    require 'rack-flash'
    require "sinatra-authentication"

    #Setting the database path for Users
    TcUserTable.cabinet_path = File.dirname(__FILE__) + 'folder/where/you/wanna/store/your/database'

    use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'
    #if you want flash messages
    use Rack::Flash

## DEFAULT ROUTES:

* get      '/login'
* get      '/logout'
* get      '/signup'
* get/post '/users'
* get       '/users/:id'
* get/post  '/users/:id/edit'
* get       '/users/:id/delete'

If you fetch any of the user pages using ajax, they will automatically render without a layout

## ADDITIONAL ROUTES WHEN USING SINBOOK FOR FACEBOOK INTEGRATION:

* get      '/receiver'
* get      '/connect'

## FLASH MESSAGES

Flash messages are implemented using rack-flash. To set them up add this to your code:

    require 'rack-flash'

    #be sure and do this after after 'use Rack:Session:Cookie...'
    use Rack::Flash

And then sinatra-authentication related flash messages will be made available through flash[:notice] (successes) and flash[:error] (failures)

    -# somewhere in a haml view:
    = flash[:notice]
    = flash[:error]

## HELPER METHODS:

This plugin provides the following helper methods for your sinatra app:

* login_required
  > which you place at the beginning of any routes you want to be protected
* current_user
* logged_in?
* render_login_logout(html_attributes)
  > Which renders login/logout and singup/edit account links.
If you pass a hash of html parameters to render_login_logout all the links will get set to them.
Which is useful for if you're using some sort of lightbox

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
The routes '/receiver' and '/connect' will be added. as well as connect links on the login and edit account pages.
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

Just remember to specify '/receiver' as the path to the xd-receiver file in your call to 'FB.init'.

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
it adds their fb_uid to their profile in the database,
which will allow them to log in using their email and password, OR their facebook account.

If they aren't already logged in to the app through the normal login form,
it creates a new user in the database without an email address or password.
They can later add this data by going to "/users/#{current_user.id}/edit",
which will allow them to log in using their email address and password, OR their facebook account.

## OVERRIDING DEFAULT VIEWS

Right now if you're going to override sinatra-authentication's views, you have to override all of them.
This is something I hope to change in a future release.

To override the default view path do something like this:

    set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "my_views/"

And then the views you'll need to define are:

* show.haml
* index.haml
* signup.haml
* login.haml
* edit.haml

To override haml, set template_engine in your Sinatra App:

    configure do
        set :template_engine, :erb # for example
    end

The signup and edit form fields are named so they pass a hash called 'user' to the server:

    %input{:name => "user[email]", :size => 30, :type => "text", :value => @user.email}
    %input{:name => "user[password]", :size => 30, :type => "password"}
    %input{:name => "user[password_confirmation]", :size => 30, :type => "password"}

    %select{:name => "user[permission_level]"}
      %option{:value => -1, :selected => @user.admin?}
        Admin
      %option{:value => 1, :selected => @user.permission_level == 1}
        Authenticated user

if you add attributes to the User class and pass them in the user hash your new attributes will be set along with the others.

The login form fields just pass a field called email and a field called password:

    %input{:name => "email", :size => 30, :type => "text"}
    %input{:name => "password", :size => 30, :type => "password"}

To add methods or properties to the User class, you have to access the underlying database user class, like so:

    class DmUser
      property :name, String
      property :has_dog, Boolean, :default => false
    end

And then to access/update your newly defined attributes you use the User class:

    current_user.name
    current_user.has_dog

    current_user.update({:has_dog => true})

    new_user = User.set({:email => 'max@max.com' :password => 'hi', :password_confirmation => 'hi', :name => 'Max', :has_dog => false})

    User.all(:has_dog => true).each do |user|
      user.update({has_dog => false})
    end

    User.all(:has_dog => false).each do |user|
      user.delete
    end

the User class passes additional method calls along to the interfacing database class, so most calls to Datamapper/Sequel/Mongomapper/RufusTokyo functions should work as expected.

If you need to get associations on current_user from the underlying ORM use current_user.db_instance, take this case for example:
    class Brain
      include DataMapper::Resource
      property :type, String
      property :iq, Integer
    end

    class DmUser
      has n, :brains
    end

    get '/' do
      @user_brains = current_user.db_instance.brains
    end

The database user classes are named as follows:

* for Datamapper:
  > DmUser
* for Sequel:
  > SequelUser
* for Rufus Tokyo:
  > TcUser
* for Mongoid:
  > MongoidUser
* for Mongomapper:
  > MmUser

## Deprecations
* All database adapters now store created_at as a Time object.

## Known issues
* First user in database is not properly recognized as site admin
  > Proposed fix: add site_admin_email option when initialization functionality is added

## Roadmap

* Move database adapter initialization, along with auto configuration of sinbook and rack flash functionality into a Sinatra::SinatraAuthentication.init(args) method
* Refactor/redesign database adapter interface, make User class AbstractUser and all ORM user classes User, with corresponding specs
* Remove Facebook connect support and add support for Omniauth
* Provide a method for overriding specific views, and/or specifying your own form partial, (passed an instance of User)
* Add Remember me (forever) checkbox to login form
* Add next url parameter support for login/signup
* Add verb selection on configuration (Sign in / Log in)
* Provide optional support through init method for inclusion of username
  > Where login form accepts either email or username (through the same field)
* Add email functionality
  > Confirmation emails
  > Forgotten password emails
* Look into what might be neccesary to allow for logging in using Ajax

## Maybe

* Allow passing custom database attributes into init method, also dynamically altering corresponding signup and user edit views. (potentially leaky abstraction)
  > As an alternative, create a generic interface for accessing database row names through the various ORMs.
  > So when users alter their User schemas, I can make my views 'Just Work'.
* Add HTTP basic auth support
* Add pluggable OAuth consumer/provider support

## License

This software is released under the Unlicense.  See the UNLICENSE file in this repository or http://unlicense.org for details.
