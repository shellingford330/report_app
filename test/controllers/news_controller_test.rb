require 'test_helper'

class NewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @news = news(:one)
  end

  test "should get new" do
    get new_news_url
    assert_redirected_to login_form_teachers_path
  end

  test "should create news" do
    assert_difference('News.count', 0) do
      post news_index_url, params: { news: { content: @news.content, title: @news.title } }
    end
    assert_redirected_to login_form_teachers_path
  end

  test "should show news" do
    get news_url(@news)
    assert_redirected_to root_path
  end

  test "should get edit" do
    get edit_news_url(@news)
    assert_redirected_to login_form_teachers_path
  end

  test "should update news" do
    patch news_url(@news), params: { news: { content: @news.content, status: @news.status, title: @news.title } }
    assert_redirected_to login_form_teachers_path
  end

  test "should destroy news" do
    assert_difference('News.count', 0) do
      delete news_url(@news)
    end

    assert_redirected_to login_form_teachers_path
  end
end
