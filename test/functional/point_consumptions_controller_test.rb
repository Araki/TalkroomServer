require 'test_helper'

class PointConsumptionsControllerTest < ActionController::TestCase
  setup do
    @point_consumption = point_consumptions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:point_consumptions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create point_consumption" do
    assert_difference('PointConsumption.count') do
      post :create, :point_consumption => { :item_type => @point_consumption.item_type, :list_id => @point_consumption.list_id, :point_consumption => @point_consumption.point_consumption, :room_id => @point_consumption.room_id }
    end

    assert_redirected_to point_consumption_path(assigns(:point_consumption))
  end

  test "should show point_consumption" do
    get :show, :id => @point_consumption
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @point_consumption
    assert_response :success
  end

  test "should update point_consumption" do
    put :update, :id => @point_consumption, :point_consumption => { :item_type => @point_consumption.item_type, :list_id => @point_consumption.list_id, :point_consumption => @point_consumption.point_consumption, :room_id => @point_consumption.room_id }
    assert_redirected_to point_consumption_path(assigns(:point_consumption))
  end

  test "should destroy point_consumption" do
    assert_difference('PointConsumption.count', -1) do
      delete :destroy, :id => @point_consumption
    end

    assert_redirected_to point_consumptions_path
  end
end
