module ArAdapter
  def self.included(base)
    base.extend ClassMethods
    base.class_eval { include ArAdapter::InstanceMethods }
  end

  module ClassMethods
    #pass all args to this
    def all
      result = ArUser.all.order("created_at DESC")
      result.map{ |r| self.new r }
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
      user = ArUser.first(pk).first
      user.destroy
      user.destroyed?
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
    end

    def saved
      @instance.valid?
    end

    def method_missing(meth, *args, &block)
      @instance.send(meth, *args, &block)
    end
  end
end
