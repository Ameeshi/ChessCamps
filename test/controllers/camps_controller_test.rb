require 'test_helper'

class CampsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_locations
    create_curriculums
    create_camps
  end

  teardown do
    delete_camps
    delete_locations
    delete_curriculums
  end
  
  test "should get index" do
    get camps_url
    assert_response :success
    assert_not_nil assigns(:active_camps)
    assert_not_nil assigns(:inactive_camps)
  end

  test "should get new" do
    get "/camps/new"
    assert_response :success
  end

  test "should get edit" do
    get edit_camp_url(@camp1.id)
    assert_not_nil assigns(:camp)
    assert_equal "Mastering Chess Tactics", assigns(:camp).curriculum.name
    assert_response :success
  end

  test "should create a new camp" do
    assert_difference('Camp.count', 1) do
      post camps_url, params: {camp: { curriculum_id: @camp1.curriculum_id, location_id: @camp1.location_id, cost: 150, start_date: Date.new(2018,8,16), end_date: Date.new(2018,8,20), time_slot: "am", max_students: 10, active: true }}
    end
    assert_redirected_to camp_path(assigns(:camp))
    assert_equal "Mastering Chess Tactics was added to the system.", flash[:notice]
  end

  test "should fail to create a new camp" do
    post camps_url, params: {camp: { curriculum_id: false, location_id: @camp1.location_id, cost: @camp1.cost, start_date: Date.new(2018,9,16), end_date: Date.new(2018,9,16), time_slot: @camp1.time_slot, max_students: @camp1.max_students, active: @camp1.active }}
    assert_template :new
  end

  test "should show camp" do
    create_users
    create_instructors
    create_camp_instructors
    get camp_url(@camp1)
    assert_not_nil assigns(:camp)
    assert_not_nil assigns(:instructors)
    assert_equal "Mastering Chess Tactics", assigns(:camp).curriculum.name
    assert_response :success
    delete_camp_instructors
    delete_instructors
    delete_users
  end

  test "should update a camp" do
    patch camp_url(@camp1), params: {id: @camp1.id, camp: { curriculum_id: @camp1.curriculum_id, location_id: @camp1.location_id, cost: @camp1.cost, start_date: Date.new(2018,10,16), end_date: Date.new(2018,10,16), time_slot: @camp1.time_slot, max_students: 5, active: @camp1.active }}
    assert_redirected_to camp_url(@camp1)
    assert_equal "Mastering Chess Tactics was revised in the system.", flash[:notice]   
  end

  test "should fail to update a camp" do
    patch camp_url(@camp1), params: {id: @camp1.id, camp: { curriculum_id: @camp1.curriculum_id, location_id: @camp1.location_id, cost: @camp1.cost, start_date: @camp1.start_date, end_date: @camp1.end_date, time_slot: @camp1.time_slot, max_students: 20, active: @camp1.active }}
    assert_template :edit
  end

  test "should destroy location" do
    assert_difference('Camp.count', -1) do
      delete camp_url(@camp1)
    end
    assert_redirected_to camps_path
    assert_equal "Mastering Chess Tactics was removed from the system.", flash[:notice]
  end
  
end