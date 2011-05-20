if Object.const_defined?("DataMapper")
  #require 'dm-core'
  require 'dm-timestamps'
  require 'dm-validations'
  require Pathname(__FILE__).dirname.expand_path.to_s + "/datamapper_user.rb"
  require Pathname(__FILE__).dirname.expand_path.to_s + "/dm_adapter.rb"
elsif Object.const_defined?("Rufus") && Rufus.const_defined?("Tokyo")
  require Pathname(__FILE__).dirname.expand_path.to_s + "/rufus_tokyo_user.rb"
  require Pathname(__FILE__).dirname.expand_path.to_s + "/tc_adapter.rb"
elsif Object.const_defined?("MongoMapper")
  require Pathname(__FILE__).dirname.expand_path.to_s + "/mongomapper_user.rb"
  require Pathname(__FILE__).dirname.expand_path.to_s + "/mm_adapter.rb"
elsif Object.const_defined?("Sequel")
  require Pathname(__FILE__).dirname.expand_path.to_s + "/sequel_user.rb"
  require Pathname(__FILE__).dirname.expand_path.to_s + "/sequel_adapter.rb"
elsif Object.const_defined?("Mongoid")
  require Pathname(__FILE__).dirname.expand_path.to_s + "/mongoid_user.rb"
  require Pathname(__FILE__).dirname.expand_path.to_s + "/mongoid_adapter.rb"
end

class User
  if Object.const_defined?("DataMapper")
    include DmAdapter
  elsif Object.const_defined?("Rufus")
    include TcAdapter
  elsif Object.const_defined?("MongoMapper")
    include MmAdapter 
  elsif Object.const_defined?("Sequel")
    include SequelAdapter
  elsif Object.const_defined?("Mongoid")
    include MongoidAdapter
  else
    throw "you need to require either 'dm-core', 'mongo_mapper', 'sequel', 'mongoid', or 'rufus-tokyo' for sinatra-authentication to work"
  end

  def initialize(interfacing_class_instance)
    @instance = interfacing_class_instance
  end

  def id
    @instance.id
  end

  def self.authenticate(email, pass)
    current_user = get(:email => email)
    return nil if current_user.nil?
    return current_user if User.encrypt(pass, current_user.salt) == current_user.hashed_password
    nil
  end

  def db_instance
    @instance
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

  #def self.page_limit
  #  20
  #end

  #def self.page_offset(page = 0)
  #  page.to_i * self.page_limit
  #end
end

class Hash
  def stringify
    inject({}) do |options, (key, value)|
      options[key.to_s] = value.to_s
      options
    end
  end

  def stringify!
    each do |key, value|
      delete(key)
      store(key.to_s, value.to_s)
    end
  end
end
