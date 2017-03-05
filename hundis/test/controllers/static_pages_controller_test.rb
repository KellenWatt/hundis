require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get Home" do
    get static_pages_Home_url
    assert_response :success
  end

  test "should get Problems" do
    get static_pages_Problems_url
    assert_response :success
  end

  test "should get User_Signin" do
    get static_pages_User_Signin_url
    assert_response :success
  end

  test "should get Create_User" do
    get static_pages_Create_User_url
    assert_response :success
  end

  test "should get User_Account" do
    get static_pages_User_Account_url
    assert_response :success
  end

end
