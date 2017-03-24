require 'test_helper'

class CompetesInsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @competes_in = competes_ins(:one)
  end

  test "should get index" do
    get competes_ins_url
    assert_response :success
  end

  test "should get new" do
    get new_competes_in_url
    assert_response :success
  end

  test "should create competes_in" do
    assert_difference('CompetesIn.count') do
      post competes_ins_url, params: { competes_in: {  } }
    end

    assert_redirected_to competes_in_url(CompetesIn.last)
  end

  test "should show competes_in" do
    get competes_in_url(@competes_in)
    assert_response :success
  end

  test "should get edit" do
    get edit_competes_in_url(@competes_in)
    assert_response :success
  end

  test "should update competes_in" do
    patch competes_in_url(@competes_in), params: { competes_in: {  } }
    assert_redirected_to competes_in_url(@competes_in)
  end

  test "should destroy competes_in" do
    assert_difference('CompetesIn.count', -1) do
      delete competes_in_url(@competes_in)
    end

    assert_redirected_to competes_ins_url
  end
end
