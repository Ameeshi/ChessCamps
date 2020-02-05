require 'test_helper'

class CurriculumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_curriculums
  end

  teardown do
    delete_curriculums
  end
  
  test "should get index" do
    get curriculums_url
    assert_response :success
    assert_not_nil assigns(:curriculums)
  end

  test "should get new" do
    get "/curriculums/new"
    assert_response :success
  end

  test "should get edit" do
    get edit_curriculum_url(@tactics.id)
    assert_not_nil assigns(:curriculum)
    assert_equal "Mastering Chess Tactics", assigns(:curriculum).name
    assert_response :success
  end

  test "should create a new curriculum" do
    assert_difference('Curriculum.count', 1) do
      post curriculums_url, params: {curriculum: { name: "Advanced Chess Tactics", min_rating: 500, max_rating: 900, active: true }}
    end
    assert_redirected_to curriculum_path(assigns(:curriculum))
    assert_equal "Advanced Chess Tactics was added to the system.", flash[:notice]
  end

  test "should fail to create a new curriculum" do
    post curriculums_url, params: {curriculum: { name: nil, min_rating: 500, max_rating: 900, active: true }}
    assert_template :new
  end

  test "should show curriculum" do
    create_locations
    create_camps
    get curriculum_url(@tactics)
    assert_not_nil assigns(:curriculum)
    assert_not_nil assigns(:past_camps_using)
    assert_not_nil assigns(:upcoming_camps_using)
    assert_equal "Mastering Chess Tactics", assigns(:curriculum).name
    assert_response :success
    delete_camps
    delete_locations
  end

  test "should update a curriculum" do
    patch curriculum_url(@tactics), params: {curriculum: { min_rating: 400, max_rating: 900, active: true }}
    assert_redirected_to curriculum_url(@tactics)
    assert_equal "Mastering Chess Tactics was revised in the system.", flash[:notice]   
  end

  test "should fail to update a curriculum" do
    patch curriculum_url(@tactics), params: {curriculum: { min_rating: -400, max_rating: 900, active: true }}
    assert_template :edit
  end

  test "should destroy location" do
    assert_difference('Curriculum.count', -1) do
      delete curriculum_url(@tactics)
    end
    assert_redirected_to curriculums_path
    assert_equal "Mastering Chess Tactics was removed from the system.", flash[:notice]
  end
  
end