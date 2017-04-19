require 'test_helper'

class ProblemKeywordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @problem_keyword = problem_keywords(:one)
  end

  test "should get index" do
    get problem_keywords_url
    assert_response :success
  end

  test "should get new" do
    get new_problem_keyword_url
    assert_response :success
  end

  test "should create problem_keyword" do
    assert_difference('ProblemKeyword.count') do
      post problem_keywords_url, params: { problem_keyword: { keyword: @problem_keyword.keyword, problem_id: @problem_keyword.problem_id } }
    end

    assert_redirected_to problem_keyword_url(ProblemKeyword.last)
  end

  test "should show problem_keyword" do
    get problem_keyword_url(@problem_keyword)
    assert_response :success
  end

  test "should get edit" do
    get edit_problem_keyword_url(@problem_keyword)
    assert_response :success
  end

  test "should update problem_keyword" do
    patch problem_keyword_url(@problem_keyword), params: { problem_keyword: { keyword: @problem_keyword.keyword, problem_id: @problem_keyword.problem_id } }
    assert_redirected_to problem_keyword_url(@problem_keyword)
  end

  test "should destroy problem_keyword" do
    assert_difference('ProblemKeyword.count', -1) do
      delete problem_keyword_url(@problem_keyword)
    end

    assert_redirected_to problem_keywords_url
  end
end
