require 'test_helper'

class StockSetsControllerTest < ActionController::TestCase
  setup do
    @stock_set = stock_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_set" do
    assert_difference('StockSet.count') do
      post :create, :stock_set => @stock_set.attributes
    end

    assert_redirected_to stock_set_path(assigns(:stock_set))
  end

  test "should show stock_set" do
    get :show, :id => @stock_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_set.to_param
    assert_response :success
  end

  test "should update stock_set" do
    put :update, :id => @stock_set.to_param, :stock_set => @stock_set.attributes
    assert_redirected_to stock_set_path(assigns(:stock_set))
  end

  test "should destroy stock_set" do
    assert_difference('StockSet.count', -1) do
      delete :destroy, :id => @stock_set.to_param
    end

    assert_redirected_to stock_sets_path
  end
end
