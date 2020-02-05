require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:family)
  should have_many(:registrations)
  should have_many(:camps).through(:registrations)

  # test validations with matchers (as possible)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:family_id)
  should validate_numericality_of(:family_id).only_integer.is_greater_than(0)

  should allow_value(1000).for(:rating)
  should allow_value(100).for(:rating)
  should allow_value(2872).for(:rating)
  should allow_value(0).for(:rating)
  should allow_value(nil).for(:rating)
  should_not allow_value(3001).for(:rating)
  should_not allow_value(50).for(:rating)
  should_not allow_value(-1).for(:rating)
  should_not allow_value(500.50).for(:rating)
  should_not allow_value("bad").for(:rating)

  should allow_value(18.years.ago.to_date).for(:date_of_birth)
  should allow_value(5.years.ago.to_date).for(:date_of_birth)
  should_not allow_value(Date.today).for(:date_of_birth)
  should_not allow_value(1.day.from_now.to_date).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(2).for(:date_of_birth)
  should_not allow_value(3.14159).for(:date_of_birth)

  # set up context
  context "Within context" do
    setup do 
      create_family_users
      create_families
      create_students
    end
    
    teardown do
      delete_students
      delete_families
      delete_family_users
    end

    should "verify that the student's family is active in the system" do
      # test the inactive family
      create_inactive_families
      alan = FactoryBot.build(:student, family: @ellis, first_name: "Alan")
      deny alan.valid?
      delete_inactive_families
      # test the nonexistent family
      simpsons = FactoryBot.build(:family, family_name: "Simpsons")
      bart = FactoryBot.build(:student, family: simpsons, first_name: "Bart")
      deny bart.valid?
    end

    should "verify that student with no rating has default set to zero" do
      create_inactive_students
      assert_equal 0, @ellen.rating
      delete_inactive_students
    end

    should "show that name method works" do
      assert_equal "Skirpan, Zach", @zach.name
      assert_equal "Regan, Peter", @peter.name
    end
    
    should "show that proper_name method works" do
      assert_equal "Kelsey Regan", @kelsey.proper_name
      assert_equal "Max Skirpan", @max.proper_name
    end

    should "have working age method" do 
      assert_equal 11, @kelsey.age  # Kelsey is a few weeks older than 11
      assert_equal 9, @peter.age    # Peter just turned 9 on this day
    end

    should "sort students in alphabetical order" do
      assert_equal ["Gruberman, Ted", "Regan, Kelsey", "Regan, Peter", "Regan, Sean", "Skirpan, Max", "Skirpan, Zach"], Student.alphabetical.all.map(&:name)
    end

    should "show that there are six active students" do
      create_inactive_students
      assert_equal 6, Student.active.size
      assert_equal ["Kelsey", "Max", "Peter", "Sean", "Ted", "Zach"], Student.active.all.map(&:first_name).sort
      delete_inactive_students
    end
    
    should "show that there is one inactive student" do
      create_inactive_students
      assert_equal 1, Student.inactive.size
      assert_equal ["Ellen"], Student.inactive.all.map(&:first_name).sort
      delete_inactive_students
    end

    should "have working below_rating scope" do |variable|
      assert_equal 4, Student.below_rating(1000).size
      assert_equal ["Kelsey", "Max", "Peter", "Ted"], Student.below_rating(1000).all.map(&:first_name).sort      
    end

    should "have working at_or_above_rating scope" do
      # Zach is at 1010 so set the floor there instead of 1000 to test edge case
      assert_equal 2, Student.at_or_above_rating(1010).size
      assert_equal ["Sean", "Zach"], Student.at_or_above_rating(1010).all.map(&:first_name).sort      
    end

    should "allow a student with no past camps to be destroyed" do
      # check against student who has never had a registration (and no one has yet...)
      assert @sean.destroy
      # check against student with one upcoming registration
      create_curriculums
      create_locations
      create_camps
      create_registrations
      assert_equal 3, @camp4.registrations.count
      assert @zach.destroy
      @camp4.reload
      assert_equal 2, @camp4.registrations.count
      delete_registrations
      delete_camps
      delete_locations
      delete_curriculums
    end

    should "deactive a student with past camps rather than destroy" do
      # check against student with one upcoming registration
      create_curriculums
      create_locations
      create_camps
      create_registrations
      # move camp 1 into the past
      @camp1.update_attribute(:start_date, 52.weeks.ago.to_date)
      @camp1.update_attribute(:end_date, 51.weeks.ago.to_date)
      assert_equal 3, @camp4.registrations.count
      assert_equal 2, @peter.registrations.count
      deny @peter.destroy
      @camp4.reload
      deny @peter.active
      assert_equal 2, @camp4.registrations.count
      assert_equal 1, @peter.registrations.count
      delete_registrations
      delete_camps
      delete_locations
      delete_curriculums
    end

    should "not deactive a student because of an update rollback" do
      # check against student with one upcoming registration
      create_curriculums
      create_locations
      create_camps
      create_registrations
      # move camp 1 into the past
      @camp1.update_attribute(:start_date, 52.weeks.ago.to_date)
      @camp1.update_attribute(:end_date, 51.weeks.ago.to_date)
      assert_equal 3, @camp4.registrations.count
      assert_equal 2, @peter.registrations.count
      @peter.last_name = nil
      deny @peter.valid?
      deny @peter.save
      # peter and his registrations remain unchanged
      assert @peter.active
      assert_equal 3, @camp4.registrations.count
      assert_equal 2, @peter.registrations.count
      delete_registrations
      delete_camps
      delete_locations
      delete_curriculums
    end

    should "remove upcoming registrations for inactive student" do
      create_curriculums
      create_locations
      create_camps
      create_registrations
      assert_equal 3, @camp4.registrations.count
      assert_equal 1, @zach.registrations.count
      @zach.make_inactive
      @zach.reload
      deny @zach.active
      assert_equal 2, @camp4.registrations.count
      assert_equal 0, @zach.registrations.count
      delete_registrations
      delete_camps
      delete_locations
      delete_curriculums
    end

    ### TESTS NOT REQUIRED FOR PHASE 4
    should "show there are make_active and make_inactive methods" do
      assert @sean.active
      @sean.make_inactive
      deny @sean.active
      @sean.make_active
      assert @sean.active
    end
  end
end
