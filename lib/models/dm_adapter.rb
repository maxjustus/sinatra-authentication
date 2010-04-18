module DmAdapter
  def self.included(base)
    base.extend ClassMethods
    base.class_eval { include DmAdapter::InstanceMethods }
  end

  module ClassMethods
    def all
      result = DmUser.all
      result.collect {|instance| self.new instance}
    end

    def get(hash)
      if user = DmUser.first(hash)
        self.new user
      else
        nil
      end
    end

    def set(attributes)
      user = DmUser.new attributes
      user.save
      user
    end

    def set!(attributes)
      user = DmUser.new attributes
      user.save!
      user
    end

    def delete(pk)
      user = DmUser.first(:id => pk)
      user.destroy
    end
  end

  module InstanceMethods
    def update(attributes)
      @instance.update attributes
    end

    def method_missing(meth, *args, &block)
      #cool I just found out * on an array turns the array into a list of args for a function
      @instance.send(meth, *args, &block)
    end
  end
end
