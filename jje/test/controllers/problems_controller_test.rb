require 'test_helper'

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get problems_index_url
    assert_response :success
  end

end
