require 'test_helper'

class StockFinancialDataControllerTest < ActionController::TestCase
  setup do
    @stock_financial_datum = stock_financial_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_financial_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_financial_datum" do
    assert_difference('StockFinancialDatum.count') do
      post :create, :stock_financial_datum => @stock_financial_datum.attributes
    end

    assert_redirected_to stock_financial_datum_path(assigns(:stock_financial_datum))
  end

  test "should show stock_financial_datum" do
    get :show, :id => @stock_financial_datum.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_financial_datum.to_param
    assert_response :success
  end

  test "should update stock_financial_datum" do
    put :update, :id => @stock_financial_datum.to_param, :stock_financial_datum => @stock_financial_datum.attributes
    assert_redirected_to stock_financial_datum_path(assigns(:stock_financial_datum))
  end

  test "should destroy stock_financial_datum" do
    assert_difference('StockFinancialDatum.count', -1) do
      delete :destroy, :id => @stock_financial_datum.to_param
    end

    assert_redirected_to stock_financial_data_path
  end
end
