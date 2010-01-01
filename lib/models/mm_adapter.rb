module MmAdapter 
  def self.included(base)
    base.extend ClassMethods
    base.class_eval { include MmAdapter::InstanceMethods }
  end

  module ClassMethods
    def all
      result = MmUser.all
      result.collect {|instance| self.new instance}
    end

    def get(hash)
      if user = MmUser.first(hash)
        self.new user
      else
        nil
      end
    end

    def set(attributes)
      user = MmUser.new attributes
      user.save
      user
    end

    def set!(attributes)
      user = MmUser.new attributes
      user.save!
      user
    end

    def delete(pk)
      user = User.first(:id => pk)
      user.destroy
    end
  end

  module InstanceMethods
    def update(attributes)
      @instance.update_attributes attributes
      @instance.save
    end

    def method_missing(meth, *args, &block)
      #cool I just found out * on an array turns the array into a list of args for a function
      @instance.send(meth, *args, &block)
    end
  end
end
