require 'test_helper'

class UserSubmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_submission = user_submissions(:one)
  end

  test "should get index" do
    get user_submissions_url
    assert_response :success
  end

  test "should get new" do
    get new_user_submission_url
    assert_response :success
  end

  test "should create user_submission" do
    assert_difference('UserSubmission.count') do
      post user_submissions_url, params: { user_submission: {  } }
    end

    assert_redirected_to user_submission_url(UserSubmission.last)
  end

  test "should show user_submission" do
    get user_submission_url(@user_submission)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_submission_url(@user_submission)
    assert_response :success
  end

  test "should update user_submission" do
    patch user_submission_url(@user_submission), params: { user_submission: {  } }
    assert_redirected_to user_submission_url(@user_submission)
  end

  test "should destroy user_submission" do
    assert_difference('UserSubmission.count', -1) do
      delete user_submission_url(@user_submission)
    end

    assert_redirected_to user_submissions_url
  end
end
