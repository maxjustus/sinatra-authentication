module TcAdapter
  def self.included(base)
    base.extend ClassMethods
    base.class_eval {
      include TcAdapter::InstanceMethods
      alias :class_id :id
    }
  end

  module ClassMethods
    #TODO add pagination
    def all
      result = TcUser.query do |q|
        q.order_by 'created_at_i', :numdesc
      end

      #these will be the same for all adapters, they should be defined in the user class, and these methods should have a different name?
      result.collect {|instance| self.new instance }
    end

    def get(hash)
      if hash[:id]
        pk = hash[:id]
        result = TcUser.get(pk)
      else
        result = TcUser.query do |q|
          hash.each do |key, value|
            q.add key.to_s, :streq, value.to_s
          end
        end[0]
      end
      #elsif hash[:email]
      #  result = TcUser.query do |q|
      #    q.add 'email', :streq, hash[:email]
      #  end[0]
        #the zero is because this returns an array but get should return the first result
      #end

      if result
        self.new result
      else
        nil
      end
    end

    def set(attributes)
      user = TcUser.query do |q|
        q.add 'email', :streq, attributes['email']
      end

      if user == [] #no user
        self.new TcUser.set(attributes)
      else
        false
      end
    end

    def set!(attributes)
      self.new TcUser.set!(attributes)
    end

    def delete(pk)
      #true or false
      !!TcUser.delete(pk)
    end
  end

  module InstanceMethods
    def update(attributes)
      @instance.update attributes
    end

    def method_missing(meth, *args, &block)
      #cool I just found out * on an array turn the array into a list of args for a function
      @instance.send(meth, *args, &block)
    end

    #this was the only thing that didn't get passed on to method_missing because this is a method of object doh
    def id
      @instance.id
    end
  end
end
