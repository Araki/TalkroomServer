class CaRewardsController < ApplicationController
  # GET /ca_rewards
  # GET /ca_rewards.json
  def index
    @ca_rewards = CaReward.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ca_rewards }
    end
  end

  # GET /ca_rewards/1
  # GET /ca_rewards/1.json
  def show
    @ca_reward = CaReward.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @ca_reward }
    end
  end

  # GET /ca_rewards/new
  # GET /ca_rewards/new.json
  def new
    @ca_reward = CaReward.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @ca_reward }
    end
  end

  # GET /ca_rewards/1/edit
  def edit
    @ca_reward = CaReward.find(params[:id])
  end

  # POST /ca_rewards
  # POST /ca_rewards.json
  def create
    @ca_reward = CaReward.new(params[:ca_reward])

    respond_to do |format|
      if @ca_reward.save
        format.html { redirect_to @ca_reward, :notice => 'Ca reward was successfully created.' }
        format.json { render :json => @ca_reward, :status => :created, :location => @ca_reward }
      else
        format.html { render :action => "new" }
        format.json { render :json => @ca_reward.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ca_rewards/1
  # PUT /ca_rewards/1.json
  def update
    @ca_reward = CaReward.find(params[:id])

    respond_to do |format|
      if @ca_reward.update_attributes(params[:ca_reward])
        format.html { redirect_to @ca_reward, :notice => 'Ca reward was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ca_reward.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ca_rewards/1
  # DELETE /ca_rewards/1.json
  def destroy
    @ca_reward = CaReward.find(params[:id])
    @ca_reward.destroy

    respond_to do |format|
      format.html { redirect_to ca_rewards_url }
      format.json { head :no_content }
    end
  end
end
