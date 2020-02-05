require 'test_helper'
require './app/helpers/application_helper'

class ApplicationHelperTest < ActiveSupport::TestCase

  include ApplicationHelper

  should "have a working method called 'camp_instructor_id_for'" do
    create_curriculums
    create_active_locations
    create_users
    create_instructors
    create_camps
    create_camp_instructors
    test_id = camp_instructor_id_for(@camp1, @mark)
    assert_equal @mark_c1.id, test_id
    delete_curriculums
    delete_active_locations
    delete_instructors
    delete_users
    delete_camps
    delete_camp_instructors
  end
end