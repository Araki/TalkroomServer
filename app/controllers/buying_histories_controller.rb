class BuyingHistoriesController < ApplicationController
  # GET /buying_histories
  # GET /buying_histories.json
  def index
    @buying_histories = BuyingHistory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @buying_histories }
    end
  end

  # GET /buying_histories/1
  # GET /buying_histories/1.json
  def show
    @buying_history = BuyingHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @buying_history }
    end
  end

  # GET /buying_histories/new
  # GET /buying_histories/new.json
  def new
    @buying_history = BuyingHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @buying_history }
    end
  end

  # GET /buying_histories/1/edit
  def edit
    @buying_history = BuyingHistory.find(params[:id])
  end

  # POST /buying_histories
  # POST /buying_histories.json
  def create
    @buying_history = BuyingHistory.new(params[:buying_history])

    respond_to do |format|
      if @buying_history.save
        format.html { redirect_to @buying_history, :notice => 'Buying history was successfully created.' }
        format.json { render :json => @buying_history, :status => :created, :location => @buying_history }
      else
        format.html { render :action => "new" }
        format.json { render :json => @buying_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /buying_histories/1
  # PUT /buying_histories/1.json
  def update
    @buying_history = BuyingHistory.find(params[:id])

    respond_to do |format|
      if @buying_history.update_attributes(params[:buying_history])
        format.html { redirect_to @buying_history, :notice => 'Buying history was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @buying_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /buying_histories/1
  # DELETE /buying_histories/1.json
  def destroy
    @buying_history = BuyingHistory.find(params[:id])
    @buying_history.destroy

    respond_to do |format|
      format.html { redirect_to buying_histories_url }
      format.json { head :no_content }
    end
  end
end
