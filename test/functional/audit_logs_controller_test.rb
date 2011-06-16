require 'test_helper'

class Admin::AuditLogsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_audit_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audit_log" do
    assert_difference('Admin::AuditLog.count') do
      post :create, :audit_log => { }
    end

    assert_redirected_to audit_log_path(assigns(:audit_log))
  end

  test "should show audit_log" do
    get :show, :id => admin_audit_logs(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_audit_logs(:one).id
    assert_response :success
  end

  test "should update audit_log" do
    put :update, :id => admin_audit_logs(:one).id, :audit_log => { }
    assert_redirected_to audit_log_path(assigns(:audit_log))
  end

  test "should destroy audit_log" do
    assert_difference('Admin::AuditLog.count', -1) do
      delete :destroy, :id => admin_audit_logs(:one).id
    end

    assert_redirected_to admin_audit_logs_path
  end
end
