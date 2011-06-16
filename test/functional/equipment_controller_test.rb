require 'test_helper'

class EquipmentControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:equipment)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create equipment" do
    assert_difference('Equipment.count') do
      post :create, :equipment => { }
    end

    assert_redirected_to equipment_path(assigns(:equipment))
  end

  test "should show equipment" do
    get :show, :id => equipment(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => equipment(:one).id
    assert_response :success
  end

  test "should update equipment" do
    put :update, :id => equipment(:one).id, :equipment => { }
    assert_redirected_to equipment_path(assigns(:equipment))
  end

  test "should destroy equipment" do
    assert_difference('Equipment.count', -1) do
      delete :destroy, :id => equipment(:one).id
    end

    assert_redirected_to equipment_path
  end
end
