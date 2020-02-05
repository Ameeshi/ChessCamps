require './test/contexts'
include Contexts

Given /^an initial setup$/ do
  # context used for phase 3 only
  create_curriculums
  create_active_locations
  create_instructors
  create_camps
  create_camp_instructors
  create_more_curriculums
  create_more_instructors
  create_past_camps
  create_upcoming_camps
  create_more_camp_instructors
end

Given /^no setup yet$/ do
  # assumes initial setup already run as background
  delete_curriculums
  delete_active_locations
  delete_instructors
  delete_camps
  delete_camp_instructors
  delete_more_curriculums
  delete_more_instructors
  delete_past_camps
  delete_upcoming_camps
  delete_more_camp_instructors
end