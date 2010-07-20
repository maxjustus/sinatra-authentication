class TestHelper
  def self.gen_user
    {'user[email]' => 'yodawg@gmail.com', 'user[password]' => 'password', 'user[password_confirmation]' => 'password'}
  end

  def self.gen_user_for_model
    {:email => 'yodawg@gmail.com', :password => 'password', :password_confirmation => 'password'}
  end
end

def app
  Sinatra::Application
end
