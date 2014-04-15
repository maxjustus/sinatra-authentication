class SequelUser < Sequel::Model
  attr_writer :password_confirmation
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at

  def validate
    super
    email_regexp = /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
    validates_format email_regexp, :email
    validates_presence :email
    validates_unique :email
    validates_presence :password if new?
    errors.add :passwords, ' don\'t match' unless @password == @password_confirmation
  end

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

