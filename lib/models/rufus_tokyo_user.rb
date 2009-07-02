#require Pathname(__FILE__).dirname.expand_path + "rufus_orm.rb"
class TcUser
  #include RufusOrm

  #custom_attribute :salt
  #custom_attribute :hashed_password
  #custom_attribute :hashed_permission_level
  #custom_attribute :created_at
  #custom_attribute :created_at_i

  #attribute method?
  #if I'm gonna write all this, I might as well create a tinyyyy
  #orm, that's more just like a way to define custom attributes for cabinets
  #something worth noting though is that even datamapper defines custom
  #attributes by allowing the developer to override setter methods.
  #and it just calls all the setter methods defined in the model.
  #the only trouble with this route is it assumes a predefined schema.
  #and thus it knows what setter methods to call.
  #I would write a class method that allows you to declare attributes like
  #attribute :salt, with an optional block (which gets passed a hash of attributes)
  #if a block isn't defined, it looks in the class for a salt=(attributes) function, calls it and marges the
  #result into the hash going into the database, like 'attributes.merge{"salt" => result}'
  #so my 'set' method or whatever I choose to call it, has to somehow look through each
  #declared attribute, call the method associated with it, and merge the result into the hash going
  #into the database.
  #
  #but what if I don't want an attribute passed in to be stored into the database? What if I just want to
  #create a virtual attribute, for declaring other attributes?
  #I might create a class variable that I store all the attributes in, and the I can get to it from any setter,
  #and then after I've called all the setters, I store that class variable into the database.
  #or, I do all of this on the instance level, and have a save method.

  def initialize(attributes)
    #@attributes = attributes.merge({'email' => attributes[:pk]})
    @attributes = attributes
  end

  def self.query(&block)
    connection = TcUserTable.new
    result_set = connection.query(&block)
    result_set.collect! { |result_hash| TcUser.new(result_hash) }
    connection.close
    result_set
  end

  def self.get(key)
    connection = TcUserTable.new
    result = connection[key]
    connection.close
    if result
      self.new(result.merge({:pk => key}))
    else
      false
    end
  end

  def self.set(attributes)
    #this way of validating is real crap, replace it with Validator maybe
    #and maybe replace all this hash merging with setters for the various attributes that update @attributes, and then I can call save to store to the database
    #or maybe just write a little method that makes hash merger look a little cleaner
    pk = attributes.delete(:pk) if attributes[:pk]

    email_regexp = /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
    if (attributes['password'] == attributes.delete('password_confirmation') && attributes['email'] =~ email_regexp)
      password = attributes.delete('password')
      attributes.merge!({'salt' => User.random_string(10)}) if !attributes['salt']
      attributes.merge!('hashed_password' => User.encrypt(password, attributes['salt']))
      permission_level = attributes['permission_level'] ? attributes['permission_level'] : '1'
      attributes.merge!('permission_level' => permission_level)
      attributes.merge!('created_at' => Time.now.to_s)
      attributes.merge!('created_at_i' => Time.now.to_i.to_s)

      connection = TcUserTable.new
      pk ||= connection.genuid.to_s
      #site admin if their first
      attributes.merge!({'permission_level' => '-2'}) if pk == '1'
      result = connection[pk] = attributes
      #might not need this in newer version of rufus
      result.merge!({:pk => pk})
      connection.close
      self.new(result)
    else
      false
    end
  end

  def self.delete(pk)
    connection = TcUserTable.new
    connection.delete(pk)
    connection.close
  end

  def update(attributes)
    new_attributes = @attributes.merge(attributes)
    TcUser.set(new_attributes)
  end

  def [](key)
    @attributes[key]
  end

  #saves to database and returns self
  def []=(key, value)
    @attributes[key] = value
    #change so that it sets the attributes and then you call save to save to the database?
    connection = TcUserTable.new
    connection[@attributes[:pk]] = @attributes.merge!({key => value})
    connection.close
    self
  end

  def id
    @attributes[:pk]
  end

  def admin?
    #-2 is the site admin
    @attributes['permission_level'] == '-1' || @attributes['permission_level'] == '-2'
  end

  def site_admin?
    @attributes['permission_level'] == '-2'
  end

  #from hash extension for making hashes like javascript objects
  def method_missing(meth,*args)
    if /=$/=~(meth=meth.id2name) then
      self[meth[0...-1]] = (args.length<2 ? args[0] : args)
    elsif @attributes[meth]
      @attributes[meth]
    else
      false
    end
  end
end

class TcUserTable < Rufus::Tokyo::Table
  @@path = false
  def initialize
    #make this path configurable somehow
    raise "you need to define a path for the user cabinet to be stored at, like so: TcUserTable.cabinet_path = 'someplace'" unless @@path
    super(@@path + '/users.tct', :mutex => false)
  end

  def self.cabinet_path=(path)
    @@path = path
  end
end
