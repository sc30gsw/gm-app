require 'test_helper'

class MansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mans_index_url
    assert_response :success
  end

end
