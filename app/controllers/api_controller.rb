class ApiController < ApplicationController
  
  #before_filter :check_logined
  
  #のぞくボタンのトップ画面
  def get_recent_rooms
    #<抽出条件>
    #(1)rooms.publicがTRUEである
    #(2)messages.room_id = rooms.idであること
    #(3)updated_atでDESCにソート
    #(4)rooms.idもしくはmessages.room_idが重複しないもの
    sql = 'SELECT MIN(R.id), R.public, R.updated_at, M.room_id, M.sendfrom_list_id, M.sendto_list_id, M.body FROM rooms AS R, messages AS M WHERE R.public = "t" AND M.room_id = R.id GROUP BY M.room_id ORDER BY R.updated_at DESC LIMIT 10;'
    results = ActiveRecord::Base.connection.execute(sql)
    
    val = []
    
    results.each do |result|
      sendfrom_image, sendto_image, sendto_message = nil
      obj1 = List.select(:profile_image1).where('id = ?', result["sendfrom_list_id"]).first
      sendfrom_image = obj1["profile_image1"]
      obj2 = List.select(:profile_image1).where('id = ?', result["sendto_list_id"]).first
      sendto_image = obj2["profile_image1"]
      obj3 = Message.select(:body).where('sendfrom_list_id = ?', result["sendto_list_id"]).order('id DESC').first
      
      #もし相手がメッセージ未返信だった場合を想定
      if obj3 then
        sendto_message = obj3["body"]
      else
        sendto_message = ""
      end
      
      val.push({
        :room_id => result["room_id"], 
        :updated_at => result["updated_at"], 
        :sendfrom_image => sendfrom_image, 
        :sendfrom_message => result["body"], 
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
    
    sql = 'SELECT L.id, L.nickname, L.age, L.profile_image1, L.profile, L.area, L.purpose, L.last_logined, M.room_id FROM lists AS L, messages AS M WHERE L.id = M.sendfrom_list_id '
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
    
    sql = sql + 'ORDER BY M.id DESC LIMIT 20;'
    
    results = ActiveRecord::Base.connection.execute(sql)
    
    respond_to do |format|
      format.json { render json: results }
    end
  end
  
  
  
  
  #トーク画面のアタック中のリスト結果を返すAPI
  #受け取るクエリ
  #ユーザーID：user_id
  def get_oneside_rooms
    #（１）USERがメッセージを送った相手全員のIDを取得
    sql1 = 'SELECT M.id, M.sendfrom_list_id, MIN(M.sendto_list_id) AS sendto_list_id, M.room_id, R.public, R.updated_at FROM messages AS M, rooms AS R WHERE R.id = M.room_id AND M.sendfrom_list_id = ' + params[:user_id] + ' GROUP BY M.sendto_list_id ORDER BY R.updated_at DESC;'
    results = ActiveRecord::Base.connection.execute(sql1)
    #（２）双方向でメッセージを送りあった相手全員のIDを取得
    sql2 = 'SELECT DISTINCT sendfrom_list_id FROM messages WHERE sendfrom_list_id = ( SELECT DISTINCT sendto_list_id FROM messages WHERE sendfrom_list_id = ' + params[:user_id] + ') GROUP BY sendfrom_list_id;'
    mutual_send_users = ActiveRecord::Base.connection.execute(sql2)
    
    val =[]
    
    #（１）から（２）の配列を取り除く
    mutual_send_users.each do |user|
      results.each do |result|
        if result["sendto_list_id"] == user["sendfrom_list_id"] then
          results.delete(result)
        end
      end
    end
    
    #ハッシュ配列を整形
    results.each do |result|
      nickname, profile_image, profile = nil
      obj = List.select("nickname, profile_image1, profile").where('id = ?', result["sendto_list_id"]).first
      val.push({
        :nickname => obj["nickname"], 
        :profile_image => obj["profile_image1"], 
        :profile => obj["profile"], 
        :room_updated => result["updated_at"], 
        :room_public => result["public"], 
        :room_id => result["room_id"]
      })
    end
    
    respond_to do |format|
      format.json { render json: val }
    end
    
  end
  
  #トーク画面のトーク中のリスト結果を返すAPI
  #受け取るクエリ
  #ユーザーID：user_id
  def get_bothside_rooms
    #双方向でメッセージを送りあった相手全員のIDを取得
    sql = 'SELECT M.id, M.sendfrom_list_id, MIN(M.sendto_list_id) AS sendto_list_id, M.room_id, R.public, R.updated_at FROM messages AS M, rooms AS R WHERE M.sendfrom_list_id = ( SELECT DISTINCT sendto_list_id FROM messages WHERE sendfrom_list_id = ' + params[:user_id] + ') GROUP BY M.sendfrom_list_id ORDER BY R.updated_at DESC;'
    results = ActiveRecord::Base.connection.execute(sql)
    
    val = []
    
    #ハッシュ配列を整形
    results.each do |result|
      nickname, profile_image, profile = nil
      obj = List.select("nickname, profile_image1, profile").where('id = ?', result["sendto_list_id"]).first
      val.push({
        :nickname => obj["nickname"], 
        :profile_image => obj["profile_image1"], 
        :profile => obj["profile"], 
        :room_updated => result["updated_at"], 
        :room_public => result["public"], 
        :room_id => result["room_id"]
      })
    end
    
    respond_to do |format|
      format.json { render json: val }
    end
    
  end
  
  
  
  #あるユーザーの詳細画面
  #受け取るクエリ
  #ユーザーID：user_id
  def get_detail_profile
    result = List.find(params[:user_id])
    
    respond_to do |format|
      format.json { render json: result }
    end
  end
  
  
  #あるユーザーのルームリストを返す
  #受け取るクエリ
  #ユーザーID：user_id
  def get_user_rooms
    sql = 'SELECT MIN(R.id), R.public, R.updated_at, M.room_id, M.sendfrom_list_id, M.sendto_list_id, M.body FROM rooms AS R, messages AS M WHERE R.public = "t" AND M.room_id = R.id AND ( M.sendfrom_list_id = ' + params[:user_id] + ' OR M.sendto_list_id = ' + params[:user_id] + ' ) GROUP BY M.room_id ORDER BY R.updated_at DESC LIMIT 10;'
    results = ActiveRecord::Base.connection.execute(sql)
    
    val = []
    
    #ハッシュ配列を整形
    results.each do |result|
      sendfrom_image, sendto_image, sendto_message = nil
      obj1 = List.select(:profile_image1).where('id = ?', result["sendfrom_list_id"]).first
      sendfrom_image = obj1["profile_image1"]
      obj2 = List.select(:profile_image1).where('id = ?', result["sendto_list_id"]).first
      sendto_image = obj2["profile_image1"]
      obj3 = Message.select(:body).where('sendfrom_list_id = ?', result["sendto_list_id"]).order('id DESC').first
      
      #もし相手がメッセージ未返信だった場合を想定
      if obj3 then
        sendto_message = obj3["body"]
      else
        sendto_message = ""
      end
      
      val.push({
        :room_id => result["room_id"], 
        :updated_at => result["updated_at"], 
        :sendfrom_image => sendfrom_image, 
        :sendfrom_message => result["body"], 
        :sendto_image => sendto_image, 
        :sendto_message => sendto_message
      })
    end
    
    respond_to do |format|
      format.json { render json: val }
    end
    
  end
  
end