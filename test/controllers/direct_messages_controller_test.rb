require 'test_helper'

class DirectMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get direct_messages_show_url
    assert_response :success
  end

  test "should get new" do
    get direct_messages_new_url
    assert_response :success
  end

end
