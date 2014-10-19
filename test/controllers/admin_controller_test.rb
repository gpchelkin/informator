require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get select" do
    get :select
    assert_response :success
  end

  test "should get shown" do
    get :shown
    assert_response :success
  end

  test "should get add" do
    get :add
    assert_response :success
  end

end
