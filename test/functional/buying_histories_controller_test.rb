require 'test_helper'

class BuyingHistoriesControllerTest < ActionController::TestCase
  setup do
    @buying_history = buying_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buying_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buying_history" do
    assert_difference('BuyingHistory.count') do
      post :create, :buying_history => { :list_id => @buying_history.list_id, :platform => @buying_history.platform, :transaction_id => @buying_history.transaction_id }
    end

    assert_redirected_to buying_history_path(assigns(:buying_history))
  end

  test "should show buying_history" do
    get :show, :id => @buying_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @buying_history
    assert_response :success
  end

  test "should update buying_history" do
    put :update, :id => @buying_history, :buying_history => { :list_id => @buying_history.list_id, :platform => @buying_history.platform, :transaction_id => @buying_history.transaction_id }
    assert_redirected_to buying_history_path(assigns(:buying_history))
  end

  test "should destroy buying_history" do
    assert_difference('BuyingHistory.count', -1) do
      delete :destroy, :id => @buying_history
    end

    assert_redirected_to buying_histories_path
  end
end
