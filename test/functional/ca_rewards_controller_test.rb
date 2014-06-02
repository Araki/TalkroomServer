require 'test_helper'

class CaRewardsControllerTest < ActionController::TestCase
  setup do
    @ca_reward = ca_rewards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ca_rewards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ca_reward" do
    assert_difference('CaReward.count') do
      post :create, :ca_reward => { :action_date => @ca_reward.action_date, :aff_id => @ca_reward.aff_id, :carrier => @ca_reward.carrier, :cid => @ca_reward.cid, :click_date => @ca_reward.click_date, :cname => @ca_reward.cname, :commission => @ca_reward.commission, :id => @ca_reward.id, :list_id => @ca_reward.list_id, :point => @ca_reward.point }
    end

    assert_redirected_to ca_reward_path(assigns(:ca_reward))
  end

  test "should show ca_reward" do
    get :show, :id => @ca_reward
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ca_reward
    assert_response :success
  end

  test "should update ca_reward" do
    put :update, :id => @ca_reward, :ca_reward => { :action_date => @ca_reward.action_date, :aff_id => @ca_reward.aff_id, :carrier => @ca_reward.carrier, :cid => @ca_reward.cid, :click_date => @ca_reward.click_date, :cname => @ca_reward.cname, :commission => @ca_reward.commission, :id => @ca_reward.id, :list_id => @ca_reward.list_id, :point => @ca_reward.point }
    assert_redirected_to ca_reward_path(assigns(:ca_reward))
  end

  test "should destroy ca_reward" do
    assert_difference('CaReward.count', -1) do
      delete :destroy, :id => @ca_reward
    end

    assert_redirected_to ca_rewards_path
  end
end
