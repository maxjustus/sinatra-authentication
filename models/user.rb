class User
  include DataMapper::Resource

  attr_accessor :password, :password_confirmation

  property :id, Serial, :protected => true
  property :email, String, :key => true, :nullable => false, :length => (5..40), :unique => true, :format => :email_address
  property :hashed_password, String
  property :salt, String, :protected => true, :nullable => false
  property :created_at, DateTime

  validates_present :password_confirmation
  validates_is_confirmed :password

  def self.authenticate(email, pass)
    current_user = first(:email => email)
    return nil if current_user.nil?
    return current_user if User.encrypt(pass, current_user.salt) == current_user.hashed_password
    nil
  end  

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
