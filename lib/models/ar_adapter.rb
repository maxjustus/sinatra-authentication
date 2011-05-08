module ArAdapter
  def self.included(base)
    base.extend ClassMethods
    base.class_eval { include ArAdapter::InstanceMethods }
  end

  module ClassMethods
    #pass all args to this
    def all
      result = ArUser.all(:order => [:created_at.desc])
      result.collect {|instance| self.new instance}
    end

    def get(hash)
      if user = ArUser.where(hash).first
        self.new user
      else
        nil
      end
    end

    def set(attributes)
      user = ArUser.new attributes
      user.save
      self.new user
    end

    def set!(attributes)
      user = ArUser.new attributes
      user.save!
      self.new user
    end

    def delete(pk)
      user = ArUser.first(:id => pk)
      user.destroy
    end
  end

  module InstanceMethods
    def valid
      @instance.valid?
    end

    def errors
      @instance.errors.collect do |k,v|
        "#{k} #{v}"
      end.join(', ')
    end

    def update(attributes)
      @instance.update_attributes attributes
      #self
    end

    def method_missing(meth, *args, &block)
      #cool I just found out * on an array turns the array into a list of args for a function
      @instance.send(meth, *args, &block)
    end
  end
end
