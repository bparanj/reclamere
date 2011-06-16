require 'test_helper'

class Admin::PickupLocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_pickup_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pickup_location" do
    assert_difference('Admin::PickupLocation.count') do
      post :create, :pickup_location => { }
    end

    assert_redirected_to pickup_location_path(assigns(:pickup_location))
  end

  test "should show pickup_location" do
    get :show, :id => admin_pickup_locations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_pickup_locations(:one).id
    assert_response :success
  end

  test "should update pickup_location" do
    put :update, :id => admin_pickup_locations(:one).id, :pickup_location => { }
    assert_redirected_to pickup_location_path(assigns(:pickup_location))
  end

  test "should destroy pickup_location" do
    assert_difference('Admin::PickupLocation.count', -1) do
      delete :destroy, :id => admin_pickup_locations(:one).id
    end

    assert_redirected_to admin_pickup_locations_path
  end
end
