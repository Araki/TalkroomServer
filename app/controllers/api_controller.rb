class ApiController < ApplicationController
  
  before_filter :check_logined
  
  #のぞくボタンのトップ画面
  def get_recent_rooms
    
    #<抽出条件>
    #(1)rooms.publicがTRUEである
    #(2)messages.room_id = rooms.idであること
    #(3)updated_atでDESCにソート
    #(4)rooms.idもしくはmessages.room_idが重複しないもの
    
    sql = 'SELECT MIN(R.id), R.public, R.updated_at, M.room_id, M.sendfrom_list_id, M.sendto_list_id, M.body FROM rooms AS R, messages AS M WHERE R.public = "t" AND M.room_id = R.id GROUP BY M.room_id ORDER BY R.updated_at DESC LIMIT 10;'
    @results = ActiveRecord::Base.connection.execute(sql)
    
    val =[]

    @results.each do |result|
      roomid, updatedtime, sendfrom_image, sendfrom_message, sendto_image, sendto_message = nil
      roomid = result["room_id"]
      updatedtime = result["updated_at"]
      obj1 = List.select(:profile_image1).where('id = ?', result["sendfrom_list_id"]).first
      sendfrom_image = obj1["profile_image1"]
      sendfrom_message = result["body"]
      obj2 = List.select(:profile_image1).where('id = ?', result["sendto_list_id"]).first
      sendto_image = obj2["profile_image1"]
      obj3 = Message.select(:body).where('sendfrom_list_id = ?', result["sendto_list_id"]).order('id DESC').first
      sendto_message = obj3["body"]
      val.push({
        :room_id => roomid, 
        :updated_at => updatedtime, 
        :sendfrom_image => sendfrom_image, 
        :sendfrom_message => sendfrom_message, 
        :sendto_image => sendto_image, 
        :sendto_message => sendto_message
      })
    end

    respond_to do |format|
      format.json { render json: val }
    end
  end
  
  #「年代」「エリア」「目的」から検索し、結果を返すAPI
  #受け取るクエリ
  #年代：age
  #エリア：area
  #目的：purpose
  def get_search_users
    age = params[:age]
    area = params[:area]
    purpose = params[:purpose]
    
    logger.info(age)
    logger.info(area)
    logger.info(purpose)
    
    sql = 'SELECT L.id, L.nickname, L.age, L.profile_image1, L.profile, L.area, L.purpose, L.last_logined FROM lists AS L, messages AS M WHERE L.id = M.sendfrom_list_id '
    if params[:age] == "" && params[:area] == "" && params[:purpose] == "" then
    else
      if params[:age] != "" then
        sql = sql + 'AND L.age = ' + params[:age] + ' '
      end
      if params[:area] != "" then
        sql = sql + 'AND L.area = ' + params[:area] + ' '
      end
      if params[:purpose] != "" then
        sql = sql + 'AND L.purpose = ' + params[:purpose] + ' '
      end
    end
    
    sql = sql +'ORDER BY M.id DESC LIMIT 20;'
    
    results = ActiveRecord::Base.connection.execute(sql)
    
    respond_to do |format|
      format.json { render json: results }
    end
  end
end