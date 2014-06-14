class IosTransactionsController < ApplicationController
  # GET /ios_transactions
  # GET /ios_transactions.json
  def index
    @ios_transactions = IosTransaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ios_transactions }
    end
  end

  # GET /ios_transactions/1
  # GET /ios_transactions/1.json
  def show
    @ios_transaction = IosTransaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @ios_transaction }
    end
  end

  # GET /ios_transactions/new
  # GET /ios_transactions/new.json
  def new
    @ios_transaction = IosTransaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @ios_transaction }
    end
  end

  # GET /ios_transactions/1/edit
  def edit
    @ios_transaction = IosTransaction.find(params[:id])
  end

  # POST /ios_transactions
  # POST /ios_transactions.json
  def create
    @ios_transaction = IosTransaction.new(params[:ios_transaction])

    respond_to do |format|
      if @ios_transaction.save
        format.html { redirect_to @ios_transaction, :notice => 'Ios transaction was successfully created.' }
        format.json { render :json => @ios_transaction, :status => :created, :location => @ios_transaction }
      else
        format.html { render :action => "new" }
        format.json { render :json => @ios_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ios_transactions/1
  # PUT /ios_transactions/1.json
  def update
    @ios_transaction = IosTransaction.find(params[:id])

    respond_to do |format|
      if @ios_transaction.update_attributes(params[:ios_transaction])
        format.html { redirect_to @ios_transaction, :notice => 'Ios transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ios_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ios_transactions/1
  # DELETE /ios_transactions/1.json
  def destroy
    @ios_transaction = IosTransaction.find(params[:id])
    @ios_transaction.destroy

    respond_to do |format|
      format.html { redirect_to ios_transactions_url }
      format.json { head :no_content }
    end
  end
end
