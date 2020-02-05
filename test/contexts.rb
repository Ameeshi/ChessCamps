# require needed files
require './test/sets/curriculum_contexts'
require './test/sets/instructor_contexts'
require './test/sets/camp_contexts'
require './test/sets/camp_instructor_contexts'
require './test/sets/location_contexts'
require './test/sets/family_contexts'
require './test/sets/student_contexts'
require './test/sets/registration_contexts'
require './test/sets/user_contexts'
require './test/sets/credit_card_contexts'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::CurriculumContexts
  include Contexts::InstructorContexts
  include Contexts::CampContexts
  include Contexts::CampInstructorContexts
  include Contexts::LocationContexts
  include Contexts::FamilyContexts
  include Contexts::StudentContexts
  include Contexts::RegistrationContexts
  include Contexts::UserContexts
  include Contexts::CreditCardContexts

  def create_unit_test_contexts
    create_users
    create_family_users
    puts "Built users"
    create_instructors
    puts "Built instructors"
    create_curriculums
    puts "Built curriculums"
    create_locations
    puts "Built locations"
    create_camps
    puts "Built camps"
    create_families
    puts "Built families"
    create_students
    puts "Built students"
    create_paid_registrations
    create_deposit_registrations
    puts "Built registrations"
  end
end