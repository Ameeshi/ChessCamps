require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_locations
  end

  teardown do
    delete_locations
  end

  test "should get index" do
    get locations_url
    assert_response :success
    assert_not_nil assigns(:active_locations)
    assert_not_nil assigns(:inactive_locations)
    assert_equal %w[ACAC Carnegie\ Mellon North\ Side], assigns(:active_locations).map(&:name)
    assert_equal %w[Squirrel\ Hill], assigns(:inactive_locations).map(&:name)
  end

  test "should get new" do
    get new_location_url
    assert_response :success
  end

  test "should create a new location" do
    assert_difference('Location.count') do
      post locations_url, params: { location: { name: "CMU", street_1: @cmu.street_1, street_2: @cmu.street_2, city: @cmu.city, state: @cmu.state, zip: @cmu.zip, max_capacity: @cmu.max_capacity, active: @cmu.active } }
    end
    assert_redirected_to location_url(assigns(:location))
    assert_equal "CMU location was added to the system.", flash[:notice]
  end

  test "should fail to create a new location" do
    post locations_url, params: { location: { name: @cmu.name, street_2: @cmu.street_2, city: @cmu.city, state: @cmu.state, zip: @cmu.zip, max_capacity: @cmu.max_capacity, active: @cmu.active } }
    assert_template :new
  end

  test "should show location" do
    create_curriculums
    create_camps
    get location_url(@cmu.id)
    assert_not_nil assigns(:location)
    assert_not_nil assigns(:upcoming_camps_at_location)
    assert_equal "Carnegie Mellon", assigns(:location).name
    assert_response :success
    delete_camps
    delete_curriculums
  end

  test "should get edit" do
    get edit_location_url(@cmu.id)
    assert_not_nil assigns(:location)
    assert_equal "Carnegie Mellon", assigns(:location).name
    assert_response :success
  end

  test "should update a location" do
    patch location_url(@cmu.id), params: { location: { name: "Pitt", street_1: @cmu.street_1, street_2: @cmu.street_2, city: @cmu.city, state: @cmu.state, zip: @cmu.zip, max_capacity: @cmu.max_capacity, active: @cmu.active } }
    assert_redirected_to location_url(assigns(:location))
    assert_equal "Pitt location was revised in the system.", flash[:notice]
  end

  test "should fail to update a location" do
    patch location_url(@cmu.id), params: { location: { name: @cmu.name, street_1: nil, street_2: @cmu.street_2, city: @cmu.city, state: @cmu.state, zip: @cmu.zip, max_capacity: @cmu.max_capacity, active: @cmu.active } }
    assert_template :edit
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete location_url(@cmu.id)
    end
    assert_redirected_to locations_url
    assert_equal "Carnegie Mellon location was removed from the system.", flash[:notice]
  end
end