require 'test_helper'

class PortfolioDemoControllerTest < ActionController::TestCase
  test "should get value_history" do
    get :value_history
    assert_response :success
  end

end
