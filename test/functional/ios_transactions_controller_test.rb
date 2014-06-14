require 'test_helper'

class IosTransactionsControllerTest < ActionController::TestCase
  setup do
    @ios_transaction = ios_transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ios_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ios_transaction" do
    assert_difference('IosTransaction.count') do
      post :create, :ios_transaction => { :bvrs => @ios_transaction.bvrs, :product_id => @ios_transaction.product_id, :purchase_date => @ios_transaction.purchase_date, :transaction_id => @ios_transaction.transaction_id, :type => @ios_transaction.type }
    end

    assert_redirected_to ios_transaction_path(assigns(:ios_transaction))
  end

  test "should show ios_transaction" do
    get :show, :id => @ios_transaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ios_transaction
    assert_response :success
  end

  test "should update ios_transaction" do
    put :update, :id => @ios_transaction, :ios_transaction => { :bvrs => @ios_transaction.bvrs, :product_id => @ios_transaction.product_id, :purchase_date => @ios_transaction.purchase_date, :transaction_id => @ios_transaction.transaction_id, :type => @ios_transaction.type }
    assert_redirected_to ios_transaction_path(assigns(:ios_transaction))
  end

  test "should destroy ios_transaction" do
    assert_difference('IosTransaction.count', -1) do
      delete :destroy, :id => @ios_transaction
    end

    assert_redirected_to ios_transactions_path
  end
end
