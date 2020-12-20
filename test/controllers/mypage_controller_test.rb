require 'test_helper'

class MypageControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get mypage_top_url
    assert_response :success
  end

end
