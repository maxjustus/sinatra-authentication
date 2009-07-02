class DmUser
  include DataMapper::Resource

  attr_accessor :password, :password_confirmation

  property :id, Serial, :protected => true
  property :email, String, :key => true, :nullable => false, :length => (5..40), :unique => true, :format => :email_address
  property :hashed_password, String
  property :salt, String, :protected => true, :nullable => false
  property :created_at, DateTime
  property :permission_level, Integer, :default => 1

  validates_present :password_confirmation, :unless => Proc.new { |t| t.hashed_password }
  validates_present :password, :unless => Proc.new { |t| t.hashed_password }
  validates_is_confirmed :password

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
