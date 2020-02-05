require 'test_helper'

class InstructorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_users
    create_instructors
  end

  teardown do
    delete_instructors
    delete_users
  end

  test "should get index" do
    get instructors_url
    assert_not_nil assigns(:instructors)
    assert_equal %w[Alex Mark Rachel], assigns(:instructors).map(&:first_name)
    assert_response :success
  end

  test "should get new" do
    get new_instructor_url
    assert_response :success
  end  

  # test "should create new instructor" do
  #   assert_difference('Instructor.count') do
  #     post instructors_path, params: { instructor: { first_name: "Eric", last_name: @mark.last_name, email: "eheimann@example.com", active: @mark.active } }
  #   end
  #   assert_redirected_to instructor_path(Instructor.last)
  # end

  # test "should not create a new instructor with invalid params" do
  #   post instructors_path, params: { instructor: { first_name: nil, last_name: nil, phone: @mark.phone, email: "eheimann@example.com", active: @mark.active } }
  #   assert_template :new
  # end

  test "should show instructor" do
    create_locations
    create_curriculums
    create_camps
    create_camp_instructors
    get instructor_url(@mark)
    assert_not_nil assigns(:instructor)
    assert_not_nil assigns(:past_camps)
    assert_not_nil assigns(:upcoming_camps)
    assert_equal "Mark", assigns(:instructor).first_name
    assert_response :success
    delete_camp_instructors
    delete_camps
    delete_locations
    delete_curriculums
  end

  test "should get edit" do
    get edit_instructor_url(@mark)
    assert_not_nil assigns(:instructor)
    assert_equal "Mark", assigns(:instructor).first_name
    assert_response :success
  end

  test "should update a instructor" do
    patch instructor_url(@mark), params: { instructor: { first_name: @mark.first_name, last_name: @mark.last_name, bio: "This is a new bio for Mark", active: @mark.active } }
    assert_redirected_to instructor_url(@mark)
    assert_equal "Mark Heimann was revised in the system.", flash[:notice]    
  end

  test "should fail to update instructor with invalid params" do
    patch instructor_url(@mark), params: { instructor: { first_name: nil, last_name: @mark.last_name, bio: "This is a new bio for Mark", active: @mark.active } }
    assert_template :edit
  end

  # test "should destroy instructor" do
  #   assert_difference('Instructor.count', -1) { delete instructor_path(@mark) }
  #   assert_redirected_to instructors_path
  # end
  
end