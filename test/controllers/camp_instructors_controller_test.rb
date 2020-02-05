require 'test_helper'

class CampInstructorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @curriculum = FactoryBot.create(:curriculum)
    @location   = FactoryBot.create(:location)
    @camp       = FactoryBot.create(:camp, curriculum: @curriculum, location: @location)
  end

  test "should get new" do
    get new_camp_instructor_path(camp_id: @camp.id)
    assert_response :success
  end

  test "should create camp instructor" do
    @instructor      = FactoryBot.create(:instructor)
    assert_difference('CampInstructor.count') do
      post camp_instructors_path, params: { camp_instructor: { camp_id: @camp.id, instructor_id: @instructor.id  } }
    end
    assert_redirected_to camp_path(CampInstructor.last.camp)

    post camp_instructors_path, params: { camp_instructor: { camp_id: @camp.id, instructor_id: nil } }
    assert_template :new
  end


  test "should destroy camp instructor" do
    @user            = FactoryBot.create(:user)
    @instructor      = FactoryBot.create(:instructor, user: @user)
    @camp_instructor = FactoryBot.create(:camp_instructor, camp: @camp, instructor: @instructor)
    assert_difference('CampInstructor.count', -1) do
      delete camp_instructor_path(id: @camp_instructor.id)
    end

    assert_redirected_to camp_path(@camp_instructor.camp)
  end
end
