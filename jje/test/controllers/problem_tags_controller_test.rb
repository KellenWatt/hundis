require 'test_helper'

class ProblemTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @problem_tag = problem_tags(:one)
  end

  test "should get index" do
    get problem_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_problem_tag_url
    assert_response :success
  end

  test "should create problem_tag" do
    assert_difference('ProblemTag.count') do
      post problem_tags_url, params: { problem_tag: { problem_id: @problem_tag.problem_id, tag: @problem_tag.tag } }
    end

    assert_redirected_to problem_tag_url(ProblemTag.last)
  end

  test "should show problem_tag" do
    get problem_tag_url(@problem_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_problem_tag_url(@problem_tag)
    assert_response :success
  end

  test "should update problem_tag" do
    patch problem_tag_url(@problem_tag), params: { problem_tag: { problem_id: @problem_tag.problem_id, tag: @problem_tag.tag } }
    assert_redirected_to problem_tag_url(@problem_tag)
  end

  test "should destroy problem_tag" do
    assert_difference('ProblemTag.count', -1) do
      delete problem_tag_url(@problem_tag)
    end

    assert_redirected_to problem_tags_url
  end
end
