module TcAdapter
  def self.included(base)
    base.extend ClassMethods
    base.class_eval { include TcAdapter::InstanceMethods }
  end

  module ClassMethods
    #add pagination
    def all
      result = TcUser.query do |q|
        q.order_by 'created_at_i', :numdesc
      end

      #these will be the same for all adapters, they should be defined in the user class, and these methods should have a different name?
      result.collect {|instance| self.new instance }
    end

    def get(hash)
      #because with TkUser email and id are the same because the email is the id
      if hash[:email]
        pk = hash[:email]
      elsif hash[:id]
        pk = hash[:id]
      end

      if result = TcUser.get(pk)
        self.new result
      else
        nil
      end
    end

    def set(attributes)
      #if attributes[fb_id]
        #use different method
      self.new TcUser.set(attributes.delete('email'), attributes)
    end

    def delete(pk)
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
