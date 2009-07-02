class TestHelper
  def self.gen_user
    {'user[email]' => 'yodawg@gmail.com', 'user[password]' => 'password', 'user[password_confirmation]' => 'password'}
  end
end

def app
  Sinatra::Application
end
