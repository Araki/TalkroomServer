class PointConsumptionsController < ApplicationController
  # GET /point_consumptions
  # GET /point_consumptions.json
  def index
    @point_consumptions = PointConsumption.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @point_consumptions }
    end
  end

  # GET /point_consumptions/1
  # GET /point_consumptions/1.json
  def show
    @point_consumption = PointConsumption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @point_consumption }
    end
  end

  # GET /point_consumptions/new
  # GET /point_consumptions/new.json
  def new
    @point_consumption = PointConsumption.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @point_consumption }
    end
  end

  # GET /point_consumptions/1/edit
  def edit
    @point_consumption = PointConsumption.find(params[:id])
  end

  # POST /point_consumptions
  # POST /point_consumptions.json
  def create
    @point_consumption = PointConsumption.new(params[:point_consumption])

    respond_to do |format|
      if @point_consumption.save
        format.html { redirect_to @point_consumption, :notice => 'Point consumption was successfully created.' }
        format.json { render :json => @point_consumption, :status => :created, :location => @point_consumption }
      else
        format.html { render :action => "new" }
        format.json { render :json => @point_consumption.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /point_consumptions/1
  # PUT /point_consumptions/1.json
  def update
    @point_consumption = PointConsumption.find(params[:id])

    respond_to do |format|
      if @point_consumption.update_attributes(params[:point_consumption])
        format.html { redirect_to @point_consumption, :notice => 'Point consumption was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @point_consumption.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /point_consumptions/1
  # DELETE /point_consumptions/1.json
  def destroy
    @point_consumption = PointConsumption.find(params[:id])
    @point_consumption.destroy

    respond_to do |format|
      format.html { redirect_to point_consumptions_url }
      format.json { head :no_content }
    end
  end
end
