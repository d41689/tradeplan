require 'test_helper'

class BlockTtmsControllerTest < ActionController::TestCase
  setup do
    @block_ttm = block_ttms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:block_ttms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create block_ttm" do
    assert_difference('BlockTtm.count') do
      post :create, :block_ttm => @block_ttm.attributes
    end

    assert_redirected_to block_ttm_path(assigns(:block_ttm))
  end

  test "should show block_ttm" do
    get :show, :id => @block_ttm.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @block_ttm.to_param
    assert_response :success
  end

  test "should update block_ttm" do
    put :update, :id => @block_ttm.to_param, :block_ttm => @block_ttm.attributes
    assert_redirected_to block_ttm_path(assigns(:block_ttm))
  end

  test "should destroy block_ttm" do
    assert_difference('BlockTtm.count', -1) do
      delete :destroy, :id => @block_ttm.to_param
    end

    assert_redirected_to block_ttms_path
  end
end
