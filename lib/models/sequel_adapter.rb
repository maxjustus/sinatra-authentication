module SequelAdapter
  def self.included(base)
    base.extend ClassMethods
    base.class_eval { include SequelAdapter::InstanceMethods }
  end

  module ClassMethods
    def all
      result = SequelUser.order(Sequel.desc(:created_at)).all
      result.collect {|instance| self.new instance}
    end

    def get(hash)
      if user = SequelUser.first(hash)
        self.new user
      else
        nil
      end
    end

    def set(attributes)
      user = SequelUser.new attributes
      if user.valid?
        user.save
        #false
      end

      self.new user
    end

    def set!(attributes)
      user = SequelUser.new attributes
      user.save!
      self.new user
    end

    def delete(pk)
      user = SequelUser.first(:id => pk)
      user.destroy
      !user.exists?
    end
  end

  module InstanceMethods
    def errors
      @instance.errors.full_messages.join(', ')
    end

    def valid
      @instance.valid?
    end

    def update(attributes)
      @instance.set attributes
      if @instance.valid?
        @instance.save
        true
      else
        false
      end
    end

    def method_missing(meth, *args, &block)
      #cool I just found out * on an array turns the array into a list of args for a function
      @instance.send(meth, *args, &block)
    end
  end
end
