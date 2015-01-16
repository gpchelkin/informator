require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  def setup
    create(:feed, url: "http://news.yandex.ru/index.rss", use: true)
    sign_in create(:admin)
  end

  test "should get index and not nil setting" do
    get :index
    assert_response :success
    assert_not_nil assigns(:setting)
  end

  test "should post settings to setting" do
    post(:index, setting: {mode: true, expiration: 1000, frequency: 2500, autocleanup: true, display_frequency: 2})
    assert_response :success
  end

  test "should get select and not nil entries" do
    get :select
    assert_response :success
    assert_not_nil assigns(:entries)

  end

  test "should get shown and not nil entries" do
    get :shown
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test "should get notice and not nil notices" do
    get :notice
    assert_response :success
    assert_not_nil assigns(:notices)
  end


end
