require 'test_helper'

class StockCategoriesControllerTest < ActionController::TestCase
  setup do
    @stock_category = stock_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_category" do
    assert_difference('StockCategory.count') do
      post :create, :stock_category => @stock_category.attributes
    end

    assert_redirected_to stock_category_path(assigns(:stock_category))
  end

  test "should show stock_category" do
    get :show, :id => @stock_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stock_category.to_param
    assert_response :success
  end

  test "should update stock_category" do
    put :update, :id => @stock_category.to_param, :stock_category => @stock_category.attributes
    assert_redirected_to stock_category_path(assigns(:stock_category))
  end

  test "should destroy stock_category" do
    assert_difference('StockCategory.count', -1) do
      delete :destroy, :id => @stock_category.to_param
    end

    assert_redirected_to stock_categories_path
  end
end
