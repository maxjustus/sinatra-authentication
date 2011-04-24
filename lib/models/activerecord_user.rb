class ArUser < ActiveRecord::Base

  #property :id, Serial
  #property :email, String, :length => (5..40), :unique => true, :format => :email_address
  #property :hashed_password, String
  #property :salt, String
  ##Was DateTime should be DateTime?
  #property :created_at, Time
  #property :permission_level, Integer, :default => 1
  #if Sinatra.const_defined?('FacebookObject')
  #  property :fb_uid, String
  #end

  attr_accessor :password, :password_confirmation
  #protected equievelant? :protected => true doesn't exist in dm 0.10.0
  #protected :id, :salt
  #doesn't behave correctly, I'm not even sure why I did this.

  validates_uniqueness_of :email
  validates_presence_of :password_confirmation, :unless => Proc.new { |t| t.hashed_password }
  validates_presence_of :password, :unless => Proc.new { |t| t.hashed_password }
  validates_confirmation_of :password

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

  def to_ary
    self.attributes.values
  end

  protected

  def method_missing(m, *args)
    return false
  end
end
