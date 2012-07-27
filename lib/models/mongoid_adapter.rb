module MongoidAdapter 
  def self.included(base)
    base.extend ClassMethods
    base.class_eval { include MongoidAdapter::InstanceMethods }
  end

  module ClassMethods
    def all
      result = MongoidUser.criteria.order_by([[:created_at, :desc]])
      result.collect {|instance| self.new instance }
    end

    def get(hash)
      if user = MongoidUser.where(hash).first
        self.new user
      else
        nil
      end
    end

    def set(attributes)
      #puts attributes.inspect
      user = MongoidUser.new attributes
      #puts user.inspect
      #puts user.to_json
      user.save
      self.new user
    end

    def set!(attributes)
      user = MongoidUser.new attributes
      user.save(:validate => false)
      self.new user
    end

    def delete(pk)
      user = MongoidUser.find(pk)
      #returns nil on success. Is this correct? Will it return something else on failure?
      user.destroy
      user.destroyed?
    end
  end

  module InstanceMethods
    def valid
      @instance.valid?
    end

    def update(attributes)
      @instance.update_attributes(attributes)
      @instance.save
    end

    def saved
      @instance.valid?
    end

    def errors
      @instance.errors.full_messages.join(', ')
    end

    def method_missing(meth, *args, &block)
      #cool I just found out * on an array turns the array into a list of args for a function
      @instance.send(meth, *args, &block)
    end
  end
end
