require 'test_helper'
require 'base64'

class RegistrationTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:student)
  should belong_to(:camp)
  should have_one(:family).through(:student)

  # test validations with matchers
  should validate_numericality_of(:camp_id).only_integer.is_greater_than(0)
  should validate_numericality_of(:student_id).only_integer.is_greater_than(0)

  # set up context
  context "Within context" do
    setup do 
      create_family_users
      create_families
      create_students
      create_curriculums
      create_locations
      create_camps
      create_registrations
    end
    
    teardown do
      delete_family_users
      delete_families
      delete_students
      delete_curriculums
      delete_locations
      delete_camps
      delete_registrations
    end

    should "have an alphabetical scope" do
      assert_equal ["Regan, Kelsey", "Regan, Peter", "Regan, Peter", "Skirpan, Max", "Skirpan, Zach"], Registration.alphabetical.all.map{|r| r.student.name}
    end

    should "have an for_camp scope" do
      assert_equal [@peter_tactics, @max_tactics], Registration.for_camp(@camp1).sort_by{|r| r.student.last_name}
    end

    should "verify that the student is active in the system" do
      # test by trying to register the inactive student
      create_inactive_students
      bad_registration = FactoryBot.build(:registration, student: @ellen, camp: @camp1)
      deny bad_registration.valid?
      delete_inactive_students
    end

    should "verify that the camp is active in the system" do
      # test by trying to register for the inactive camp
      bad_assignment = FactoryBot.build(:registration, student: @max, camp: @camp3)
      deny bad_assignment.valid?
    end

    should "verify that the student has a rating appropriate for the camp" do
      # verify that Sean (rating 1252) can register for endgames (700-1500)
      sean_endgames = FactoryBot.build(:registration, student: @sean, camp: @camp4)
      assert sean_endgames.valid?
      # verify that Max (rating 535) cannot register for endgames (700-1500)
      max_endgames = FactoryBot.build(:registration, student: @max, camp: @camp4)
      deny max_endgames.valid?
    end

    should "verify that student is not registered for another camp at the same time" do
      camp5 = FactoryBot.create(:camp, curriculum: @endgames, location: @north) 
      bad_registration = FactoryBot.build(:registration, student: @peter, camp: camp5)
      deny bad_registration.valid?
      camp5.delete
    end

    should "identify different types of credit card by their pattern" do
      # lengths are all correct for these tests, but prefixes are not
      assert @max_tactics.valid?
      numbers = {4123456789012=>"VISA", 4123456789012345=>"VISA", 5123456789012345=>"MC", 5412345678901234=>"MC", 6512345678901234=>"DISC", 6011123456789012=>"DISC", 30012345678901=>"DCCB", 30312345678901=>"DCCB", 341234567890123=>"AMEX", 371234567890123=>"AMEX",7123456789012=>"N/A",30612345678901=>"N/A",351234567890123=>"N/A",5612345678901234=>"N/A",6612345678901234=>"N/A"}
      numbers.each do |num, name|
        @max_tactics.credit_card_number = num
        assert_equal name, @max_tactics.credit_card_type, "#{@max_tactics.credit_card_type} :: #{@max_tactics.credit_card_number}"
      end
    end
    
    should "detect different types of valid and invalid credit card numbers" do
      # similar to previous, but testing the actual validation method exists
      @max_tactics.credit_card_number = 9123456789012345
      @max_tactics.expiration_month = Date.current.month + 1
      @max_tactics.expiration_year = Date.current.year
      deny @max_tactics.valid?
      valid_numbers = %w[4123456789012345 5123456789012345 5412345678901234 6512345678901234 6011123456789012 30012345678901 30312345678901 341234567890123 371234567890123]
      valid_numbers.each do |num|
        @max_tactics.credit_card_number = num
        assert @max_tactics.valid?, "#{@max_tactics.credit_card_number}"
      end
      invalid_numbers = %w[7123456789012 30612345678901 351234567890123 5612345678901234 6612345678901234]
      invalid_numbers.each do |num|
        @max_tactics.credit_card_number = num
        deny @max_tactics.valid?, "#{@max_tactics.credit_card_number}"
      end
    end  
    
    should "detect different types of too-short credit card numbers" do
      # prefixes are all correct for these tests, but length is too short for card type
      @max_tactics.expiration_month = Date.current.month + 1
      @max_tactics.expiration_year = Date.current.year
      short_numbers = %w[412345678901 412345678901234 512345678901234 541234567890123 651234567890123 601112345678901 3001234567890 3031234567890 34123456789012 37123456789012]
      short_numbers.each do |num|
        @max_tactics.credit_card_number = num
        deny @max_tactics.valid?, "#{@max_tactics.credit_card_number}"
      end
    end 
    
    should "detect different types of too-long credit card numbers" do
      # prefixes are all correct for these tests, but length is too long for card type
      assert @max_tactics.valid?
      @max_tactics.expiration_month = Date.current.month + 1
      @max_tactics.expiration_year = Date.current.year
      long_numbers = %w[41234567890121 41234567890123451 51234567890123451 54123456789012341 65123456789012341 60111234567890121 300123456789011 303123456789011 3412345678901231 3712345678901231]
      long_numbers.each do |num|
        @max_tactics.credit_card_number = num
        deny @max_tactics.valid?, "#{@max_tactics.credit_card_number}"
      end
    end
    
    should "detect valid and invalid expiration dates" do
      assert @max_tactics.valid?
      @max_tactics.credit_card_number = "4123456789012"
      @max_tactics.expiration_month = Date.current.month
      @max_tactics.expiration_year = 1.year.ago.year
      deny @max_tactics.valid?
      @max_tactics.expiration_year = Date.current.year
      assert @max_tactics.valid?
      @max_tactics.expiration_month = Date.current.month - 1
      deny @max_tactics.valid?
      @max_tactics.expiration_month = Date.current.month + 1
      assert @max_tactics.valid?
    end

    should "have a properly formatted payment receipt that only is generated once" do
      @max_tactics.payment = nil
      assert @max_tactics.save
      @max_tactics.credit_card_number = "4123456789012"
      @max_tactics.expiration_month = Date.current.month + 1
      @max_tactics.expiration_year = Date.current.year
      assert @max_tactics.valid?
      # test that payment receipt created
      @max_tactics.pay
      assert_equal "camp: #{@max_tactics.camp_id}; student: #{@max_tactics.student_id}; amount_paid: #{@max_tactics.camp.cost}; card: #{@max_tactics.credit_card_type} ****#{@max_tactics.credit_card_number[-4..-1]}", Base64.decode64(@max_tactics.payment)
      @max_tactics.reload
      # now verify that you can't pay twice
      assert_not_nil @max_tactics.payment
      deny @max_tactics.pay
    end


    ### TESTS NOT REQUIRED FOR PHASE 4 
    should "have credit card related accessors" do
      assert Registration.new.respond_to? :credit_card_number
      assert Registration.new.respond_to? :expiration_year
      assert Registration.new.respond_to? :expiration_month
      assert Registration.new.respond_to? :credit_card_type
      assert Registration.new.respond_to?(:credit_card_number=)
      assert Registration.new.respond_to?(:expiration_year=)
      assert Registration.new.respond_to?(:expiration_month=)
      deny Registration.new.respond_to?(:credit_card_type=)
    end
  end
end
