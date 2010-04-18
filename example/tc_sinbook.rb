require 'rubygems'
require 'haml'
require 'sinbook'
require 'rufus/tokyo'
require 'sinatra'
require 'sinatra-authentication'

use Rack::Session::Cookie, :secret => "heyhihello"
TcUserTable.cabinet_path = File.dirname(__FILE__)

facebook do
  api_key 'aa2db1b96cb7b57f0c5b1d4d3d8f0a22'
  secret '21d94ee63969ae3b3f833689838ca00f'
  app_id 48652736613
  url 'peoplewithjetpacks.com:4568/'
  callback 'peoplewithjetpacks.com:4568/'
end

set :port, 4568

get '/' do
  haml :main
end

get '/test' do
  login_required
  'hihihi'
end

__END__

@@ layout
%html{:xmlns=>"http://www.w3.org/1999/xhtml", :'xmlns:fb'=>"http://www.facebook.com/2008/fbml"}
  %head
    %title Welcome to my Facebook Connect website!
    %script{:type => 'text/javascript', :src => 'http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php/en_US'}
    %script{:type => 'text/javascript', :src => 'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'}
    :javascript
      $(document).ready(function(){
        /* test facebook crap works with ajax */
        $('.sinatra-authentication-login').click(function(){
          $.get($(this).attr('href'), {}, function(data){
            $('#test_box').html(data);
          });
          return false;
        });
      });
  %body
    = render_login_logout
    = yield
    :javascript
      FB.init("#{fb.api_key}", "/receiver")
    #test_box

@@ main
- if fb[:user]
  Hi,
  %fb:profile-pic{:uid => fb[:user]}
  %fb:name{:uid => fb[:user], :useyou => 'false', :firstnameonly => 'true'}
  !
  %br/

