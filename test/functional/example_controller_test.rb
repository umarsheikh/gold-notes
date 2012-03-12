require 'test_helper'

class ExampleControllerTest < ActionController::TestCase
  test "should get cucumber_xml" do
    get :cucumber_xml
    assert_response :success
  end

  test "should get taggings" do
    get :taggings
    assert_response :success
  end

end
