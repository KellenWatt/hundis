require 'test_helper'

class ContainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contain = contains(:one)
  end

  test "should get index" do
    get contains_url
    assert_response :success
  end

  test "should get new" do
    get new_contain_url
    assert_response :success
  end

  test "should create contain" do
    assert_difference('Contain.count') do
      post contains_url, params: { contain: {  } }
    end

    assert_redirected_to contain_url(Contain.last)
  end

  test "should show contain" do
    get contain_url(@contain)
    assert_response :success
  end

  test "should get edit" do
    get edit_contain_url(@contain)
    assert_response :success
  end

  test "should update contain" do
    patch contain_url(@contain), params: { contain: {  } }
    assert_redirected_to contain_url(@contain)
  end

  test "should destroy contain" do
    assert_difference('Contain.count', -1) do
      delete contain_url(@contain)
    end

    assert_redirected_to contains_url
  end
end
