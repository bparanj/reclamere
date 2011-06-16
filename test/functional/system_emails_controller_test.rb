require 'test_helper'

class SystemEmailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_emails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_email" do
    assert_difference('SystemEmail.count') do
      post :create, :system_email => { }
    end

    assert_redirected_to system_email_path(assigns(:system_email))
  end

  test "should show system_email" do
    get :show, :id => system_emails(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => system_emails(:one).id
    assert_response :success
  end

  test "should update system_email" do
    put :update, :id => system_emails(:one).id, :system_email => { }
    assert_redirected_to system_email_path(assigns(:system_email))
  end

  test "should destroy system_email" do
    assert_difference('SystemEmail.count', -1) do
      delete :destroy, :id => system_emails(:one).id
    end

    assert_redirected_to system_emails_path
  end
end
