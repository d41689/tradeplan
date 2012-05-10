require 'test_helper'

class StockSignalsControllerTest < ActionController::TestCase
  setup do
    @stock_signal = stock_signals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_signals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_signal" do
    assert_difference('StockSignal.count') do
      post :create, :stock_signal => @stock_signal.attributes
    end

    assert_redirected_to stock_signal_path(assigns(:stock_signal))
  end

  test "should show stock_signal" do
    get :show, :id => @stock_signal.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_signal.to_param
    assert_response :success
  end

  test "should update stock_signal" do
    put :update, :id => @stock_signal.to_param, :stock_signal => @stock_signal.attributes
    assert_redirected_to stock_signal_path(assigns(:stock_signal))
  end

  test "should destroy stock_signal" do
    assert_difference('StockSignal.count', -1) do
      delete :destroy, :id => @stock_signal.to_param
    end

    assert_redirected_to stock_signals_path
  end
end
