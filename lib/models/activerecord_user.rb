unless ActiveRecord::Base.connection.table_exists?("ar_users")
  class CreateArUsers < ActiveRecord::Migration
    def self.up
      create_table :ar_users do |t|
        t.string :email
        t.string :hashed_password
        t.string :salt
        t.integer :permission_level
        t.string :fb_uid

        t.timestamps
      end

      add_index :ar_users, :email, :unique => true
    end

    def self.down
      remove_index :ar_users, :email
      drop_table :ar_users
    end
  end

  CreateArUsers.up
end

#require 'logger'
#ActiveRecord::Base.logger = Logger.new(STDOUT)

class ArUser < ActiveRecord::Base

  attr_accessor :password, :password_confirmation

  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
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
end
