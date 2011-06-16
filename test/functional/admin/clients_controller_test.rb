require 'test_helper'

class Admin::ClientsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Admin::Client.count') do
      post :create, :client => { }
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, :id => admin_clients(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_clients(:one).id
    assert_response :success
  end

  test "should update client" do
    put :update, :id => admin_clients(:one).id, :client => { }
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Admin::Client.count', -1) do
      delete :destroy, :id => admin_clients(:one).id
    end

    assert_redirected_to admin_clients_path
  end
end
