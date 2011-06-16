require 'test_helper'

class PickupLocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pickup_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pickup_location" do
    assert_difference('PickupLocation.count') do
      post :create, :pickup_location => { }
    end

    assert_redirected_to pickup_location_path(assigns(:pickup_location))
  end

  test "should show pickup_location" do
    get :show, :id => pickup_locations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pickup_locations(:one).id
    assert_response :success
  end

  test "should update pickup_location" do
    put :update, :id => pickup_locations(:one).id, :pickup_location => { }
    assert_redirected_to pickup_location_path(assigns(:pickup_location))
  end

  test "should destroy pickup_location" do
    assert_difference('PickupLocation.count', -1) do
      delete :destroy, :id => pickup_locations(:one).id
    end

    assert_redirected_to pickup_locations_path
  end
end
