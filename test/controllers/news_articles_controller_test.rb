require 'test_helper'

class NewsArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get news_articles_index_url
    assert_response :success
  end

  test "should get show" do
    get news_articles_show_url
    assert_response :success
  end

  test "should get new" do
    get news_articles_new_url
    assert_response :success
  end

end
