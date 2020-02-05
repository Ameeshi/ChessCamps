require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_secure_password

  # test validations
  should validate_presence_of(:username)

  should allow_value("admin").for(:role)
  should allow_value("instructor").for(:role)
  should allow_value("parent").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("leader").for(:role)
  should_not allow_value(nil).for(:role)

  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)
  should_not allow_value(nil).for(:email)
  
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  should_not allow_value(nil).for(:phone)
  
  
  # context
  context "Within context" do
    setup do
      create_users
    end
    
    teardown do
      delete_users
    end

    should "require users to have unique, case-insensitive usernames" do
      assert_equal "mheimann", @mark_user.username
      # try to switch to Alex's username 'tank'
      @mark_user.username = "TANK"
      deny @mark_user.valid?, "#{@mark_user.username}"
    end

    should "allow user to authenticate with password" do
      assert @mark_user.authenticate("secret")
      deny @mark_user.authenticate("notsecret")
    end

    should "require a password for new users" do
      bad_user = FactoryBot.build(:user, username: "tank", password: nil)
      deny bad_user.valid?
    end
    
    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryBot.build(:user, username: "tank", password: "secret", password_confirmation: nil)
      deny bad_user_1.valid?
      bad_user_2 = FactoryBot.build(:user, username: "tank", password: "secret", password_confirmation: "sauce")
      deny bad_user_2.valid?
    end
    
    should "require passwords to be at least four characters" do
      bad_user = FactoryBot.build(:user, username: "tank", password: "no")
      deny bad_user.valid?
    end

    should "strip non-digits from the phone number" do
      assert_equal "4123694314", @alex_user.phone
    end

    ### TESTS NOT REQUIRED FOR PHASE 4
    should "have a role? method for authorization" do
      assert @mark_user.role?(:admin)
      assert @rachel_user.role?(:instructor)
      create_family_users
      assert @regan_user.role?(:parent)
      delete_family_users
    end
  end
end
