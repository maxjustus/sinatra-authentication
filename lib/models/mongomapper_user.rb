class MmUser 
  include MongoMapper::Document

  email_regexp = /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  key :email, String, :unique => true, :format => email_regexp
  key :hashed_password, String
  key :salt, String
  key :permission_level, Integer, :default => 1
  if Sinatra.const_defined?('FacebookObject')
    key :fb_uid, String
  end

  timestamps!

  attr_accessor :password, :password_confirmation

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def admin?
    self.permission_level == -1 || self.id == 1
  end

  def site_admin?
    self.id == 1
  end

  protected

  def method_missing(m, *args)
    return false
  end
end
