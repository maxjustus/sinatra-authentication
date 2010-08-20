class MongoidUser 
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email
  field :hashed_password
  field :salt
  field :permission_level, :type => Integer, :default => 1
  if Sinatra.const_defined?('FacebookObject')
    field :fb_uid
  end

  # Validations
  validates_uniqueness_of :email
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  validates_presence_of :password
  validates_confirmation_of :password

  #attr_protected :_id, :salt

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
