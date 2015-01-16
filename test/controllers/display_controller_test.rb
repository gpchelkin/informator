require 'test_helper'

class DisplayControllerTest < ActionController::TestCase

  test "should get display index" do
    get :index
    assert_response :success
  end

end
