require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:user)
  should have_many(:students)
  should have_many(:registrations).through(:students)

  # test validations with matchers
  should validate_presence_of(:family_name)
  should validate_presence_of(:parent_first_name)

  # set up context
  context "Within context" do
    setup do 
      create_family_users
      create_families
      create_inactive_families
    end
    
    teardown do
      delete_families
      delete_inactive_families
      delete_family_users
    end

    should "sort families in alphabetical order" do
      assert_equal %w[Ellis Gruberman Regan Skirpan], Family.alphabetical.all.map(&:family_name)
    end

    should "show that there are three active families" do
      assert_equal 3, Family.active.size
      assert_equal %w[Gruberman Regan Skirpan], Family.active.all.map(&:family_name).sort
    end
    
    should "show that there is one inactive family" do
      assert_equal 1, Family.inactive.size
      assert_equal %w[Ellis], Family.inactive.all.map(&:family_name).sort
    end

    should "correctly assess that a family is not destroyable" do
      deny @regans.destroy
    end

    should "remove upcoming registrations when family is made inactive" do
      create_curriculums
      create_locations
      create_camps
      create_students
      create_registrations
      assert_equal 3, @regans.registrations.count
      @regans.make_inactive
      @regans.reload
      assert_equal 0, @regans.registrations.count
      delete_registrations
      delete_students
      delete_camps
      delete_locations
      delete_curriculums
    end

    ### TESTS NOT REQUIRED FOR PHASE 4
    should "make students inactive when family is made inactive" do
      create_curriculums
      create_locations
      create_camps
      create_students
      create_registrations
      assert_equal 3, @regans.students.active.count
      @regans.make_inactive
      @regans.reload
      assert_equal 0, @regans.students.active.count
      delete_registrations
      delete_students
      delete_camps
      delete_locations
      delete_curriculums
    end

    should "have delegates for email and phone" do
      assert @regans.respond_to?(:email)
      assert @regans.respond_to?(:phone)
      assert @regans.respond_to?(:username)
    end

    should "show there are make_active and make_inactive methods" do
      assert @regans.active
      @regans.make_inactive
      deny @regans.active
      @regans.make_active
      assert @regans.active
    end
  end
end
