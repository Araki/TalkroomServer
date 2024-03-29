class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  
  #サービス開始時にはコメントアウトを外す
  #before_filter :check_logined
    
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create

    #logger.info("Message===========")
    #logger.info(params[:body])
    #logger.info(params[:sendto_list_id])
    #logger.info(params[:sendfrom_list_id])
    #logger.info(params[:room_id])
    #logger.info("sendfrom_list_id===========")
    
    @message = Message.new(params[:message])
    #@message.sendfrom_list_id = params[:sendfrom_list_id]
    #@message.sendto_list_id = params[:sendto_list_id]
    #@message.room_id = params[:room_id]
    #@message.body = params[:body]

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, :notice => 'Message was successfully created.' }
        format.json { render :json => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.json { render :json => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, :notice => 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
end
