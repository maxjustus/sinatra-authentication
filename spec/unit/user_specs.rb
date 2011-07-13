describe User do
  before :each do
    User.all.each do |u|
      User.delete(u.id)
    end

    @user = User.set(TestHelper.gen_user_for_model)
  end

  describe 'instance' do
    describe '#update' do
      before :each do
        @user.update(:password => 'password', :password_confirmation => 'password')
      end

      it 'Returns an instance if User' do
        @user.class.should == User
      end

      it 'Should return true on success' do
        @user.update(:email => 'max@max.com', :password => 'hi', :password_confirmation => 'hi').should == true
        @user.update(:email => 'max@max.com').should == true
      end

      it 'Does not allow duplicate email addresses on update' do
        @user_two = User.set(:email => 'steve@steve.com', :password => 'hi', :password_confirmation => 'hi')
        @user.update(:email => 'steve@steve.com').should == false
        #@user.class.should == User
      end

      it 'Should say saved is false when invalid' do
        @user.update(:password => 'paz')
        @user.saved.should == false
      end
    end

    describe '#errors' do
      it 'Returns a string of errors' do
        @user.update(:password => 'paz')
        @user.errors.class.should == String && @user.errors.length.should > 0
      end
    end

    describe '#valid' do
      it 'Should return false when invalid' do
        @user.update(:password => 'hi')
        @user.valid.should == false
      end

      it 'Should validate format of email' do
        @user.update(:email => 'meeewewe!!')
        @user.valid.should == false
      end

      it 'Should return true when valid' do
        @user.valid.should == true
      end
    end
  end

  describe '#all' do
    it 'Should return an array of instances of User' do
      User.all[0].class.should == User
    end

    it 'Should return users in descending order of creation time' do
      @newest_user = User.set(:email => 'hey@hi.com', :password => 'hihihi', :password_confirmation => 'hihihi', :created_at => Time.now + 1)
      User.all[0].email.should == @newest_user.email
    end

    #it 'Should accept a page argument in a hash and limit results to 20 by default' do
    #  40.times do |n|
    #    @newest_user = User.set(:email => "#{n}hey@hi.com", :password => 'hihihi', :password_confirmation => 'hihihi', :created_at => Time.now + n)
    #  end
    #  users = User.all(:page => 0)
    #  users[0].email.should == @newest_user.email
    #  users.size.should == 20
    #  User.all(:page => 1)[0].email.should == "19hey@hi.com"
    #end
  end

  describe '#set' do
    it 'Returns an instance if User' do
      @user.class.should == User
    end

    it 'Timestamps user with Time' do
      @user.created_at.class.should == Time
    end

    it 'Should set first user in database as site admin' do
      @user.site_admin?.should == true
    end

    #it 'Should say saved is true' do
    #  @user.saved.should == true
    #end
  end

  describe '#set!' do
    before :each do
      @user = User.set!({:password => 'hi'})
    end

    it 'Returns an instance if User' do
      @user.class.should == User
    end

    #it 'Should say saved is true' do
    #  @user.saved.should == true
    #end
  end

  describe '#delete' do
    it 'Returns a boolean' do
      User.delete(@user.id).should == true
    end
  end
end
