class ApiController < ApplicationController
  
  #before_filter :check_logined
  #================================================================
  #登録されているユーザーを取得する（デバッグ用）
  #================================================================
  def get_all_users
    lists = Arel::Table.new(:lists, :as => 'sendto_lists')
    
    query = lists.
            project(lists[:id],lists[:nickname])
                
    sql = query.to_sql
    logger.info(sql)

    results = ActiveRecord::Base.connection.select(sql)
    
    val = []
    
    #ハッシュ配列を整形
    results.each do |result|
      val.push({
        :id => result["id"],
        :nickname => result["nickname"]
      })
    end
    
    respond_to do |format|
      format.json { render :json => val }
    end
  end
  
  
  
  #================================================================
  #のぞくボタンのトップ画面
  #================================================================
  def get_recent_rooms
    #<抽出条件>
    #(1)rooms.publicがTRUEである
    #(2)messages.room_id = rooms.idであること
    #(3)updated_atでDESCにソート
    #(4)rooms.idもしくはmessages.room_idが重複しないもの

    rooms = Arel::Table.new(:rooms, :as => 'rooms')
    query = rooms.
            project(rooms[:id],
                    rooms[:public],
                    rooms[:updated_at]
                    ).
            where(rooms[:public].eq(TRUE)).
            order(rooms[:updated_at].desc).
            take(100)
    sql = query.to_sql
    logger.info(sql)
    results = ActiveRecord::Base.connection.select(sql) 
   
    val = []
    results.each do |result|
      val.push({
        :room_id => result["id"], 
        :updated_at => exchangeTime(result["updated_at"].to_time)
      })
    end

    respond_to do |format|
      format.json { render :json => val }
    end

  end
  
  
  
 
 
 
   #================================================================
  #テーブルのルームサマリー情報を取得する
  #================================================================
  def get_room_summary_data
  #<抽出条件>
  #ルームIDを最大10件受取り、以下の情報を返す
  #sendfromID
  #sendtoID
  #sendfromImage
  #sendtoImage
  #sendfromMessage
  #sendtoMessage
  
  #logger.info("params[room_ids]:#{params[:room_ids]}")
  #logger.info("セパレート:#{params[:room_ids].split(",")}")
  roomAry = params[:room_ids].split(",")
  for room in roomAry do
    logger.info("ROOM:#{room}")
  end
  
  rooms = Arel::Table.new(:rooms, :as => 'rooms')
  male_messages = Arel::Table.new(:messages, :as => 'male_messages')
  female_messages = Arel::Table.new(:messages, :as => 'female_messages')
  male_lists = Arel::Table.new(:lists, :as => 'male_lists')
  female_lists = Arel::Table.new(:lists, :as => 'female_lists')
  
  query = rooms.
          join(male_messages, Arel::Nodes::OuterJoin).
          on(rooms[:male_last_message].eq(male_messages[:id])).
          join(female_messages, Arel::Nodes::OuterJoin).
          on(rooms[:female_last_message].eq(female_messages[:id])).
          join(male_lists, Arel::Nodes::OuterJoin).
          on(rooms[:male_id].eq(male_lists[:id])).
          join(female_lists, Arel::Nodes::OuterJoin).
          on(rooms[:female_id].eq(female_lists[:id])).
          project(rooms[:id],
                  rooms[:public],
                  rooms[:updated_at],
                  male_lists[:id].as('sendfrom_id'),
                  male_lists[:profile_image1].as('sendfrom_image'),
                  male_messages[:body].as('sendfrom_message'),
                  female_lists[:id].as('sendto_id'),
                  female_lists[:profile_image1].as('sendto_image'),
                  female_messages[:body].as('sendto_message')
                  ).
          where(rooms[:id].in(roomAry)).
          order(rooms[:updated_at].desc)
                  
=begin 
    sendto_lists = Arel::Table.new(:lists, :as => 'sendto_lists')
    sendfrom_lists = Arel::Table.new(:lists, :as => 'sendfrom_lists')
    messages = Arel::Table.new(:messages, :as => 'messages')
    
    query = messages.
            join(sendfrom_lists).
            on(messages[:sendfrom_list_id].eq(sendfrom_lists[:id])).
            join(sendto_lists).
            on(messages[:sendto_list_id].eq(sendto_lists[:id])).
            project(rooms[:id], 
                    rooms[:public],
                    rooms[:updated_at],
                    sendfrom_lists[:id].as('sendfrom_id'), 
                    sendfrom_lists[:profile_image1].as('sendfrom_image'), 
                    sendto_lists[:id].as('sendto_id'),
                    sendto_lists[:profile_image1].as('sendto_image'), 
                    messages[:body]
                    ).
            where(rooms[:public].eq(TRUE)).
            where(messages[:id].in(recent_unique_messages)).
            group(messages[:room_id]).
            order(rooms[:updated_at].desc).
            take(10)
=end             
                 
    
    sql = query.to_sql
    logger.info(sql)

    results = ActiveRecord::Base.connection.select(sql) 
    

    val = []

    results.each do |result|
      logger.info(result)
=begin
      obj3 = Message.select(:body).where('sendfrom_list_id = ?', result["sendto_id"]).order('id DESC').first
      #もし相手がメッセージ未返信だった場合を想定
      if obj3 then
        sendto_message = obj3["body"]
      else
        sendto_message = ""
      end
=end
      updatedtime = exchangeTime(result["updated_at"].to_time)
      
      val.push({
        :room_id => result["id"], 
        :public => result["public"],
        :updated_at => updatedtime,
        :sendfrom_id => result["sendfrom_id"],
        :sendfrom_image => result["sendfrom_image"],
        :sendfrom_message => result["sendfrom_message"], 
        :sendto_id => result["sendto_id"],
        :sendto_image => result["sendto_image"],
        :sendto_message => result["sendto_message"]
      })
    end

    respond_to do |format|
      format.json { render :json => val }
    end
  end
  
   
  
  
  
  
  
  #================================================================
  #「年代」「エリア」「目的」から検索し、結果を返すAPI
  #受け取るクエリ
  #年代：age
  #エリア：area
  #目的：purpose
  #自分のユーザーID：user_id
  #================================================================
  def get_search_users
    
    lists = Arel::Table.new(:lists, :as => 'rooms')
    rooms = Arel::Table.new(:rooms, :as => 'rooms')
    
    access_user = List.find(params[:user_id], :select => "gender")
    logger.info("GENDER: #{access_user.gender}")
        
    query = lists.
            project(lists[:id],
                    lists[:nickname],
                    lists[:age],
                    lists[:profile_image1],
                    lists[:profile],
                    lists[:area],
                    lists[:purpose],
                    lists[:last_logined]
            ).
            order(lists[:last_logined].desc)
            
    if params[:age] != "" then
      query = query.where(lists[:age].eq(params[:age]))
    end
    if params[:area] != "" then
      query = query.where(lists[:area].eq(params[:area]))
    end
    if params[:purpose] != "" then
      query = query.where(lists[:purpose].eq(params[:purpose]))
    end
    if access_user.gender == "male" then
      query = query.where(lists[:gender].not_eq(access_user.gender))
      #logger.info("##########MALE")
    elsif access_user.gender == "female" then
      query = query.where(lists[:gender].not_eq(access_user.gender))
      #logger.info("##########FEMALE")
    end
            
    sql = query.to_sql
    logger.info("============================")
    logger.info(sql)    

    results = ActiveRecord::Base.connection.select(sql)
    
    val = []
    
    results.each do |result|
      
      logintime = exchangeTime(result["last_logined"].to_time)

      val.push({
        :id => result["id"], 
        :nickname => result["nickname"], 
        :age => result["age"],
        :profile_image1 => result["profile_image1"],
        :profile => result["profile"],
        :area => result["area"],
        :purpose => result["purpose"],
        :last_logined => logintime
        #:room_id => result["room_id"]
      })

    end
    
    respond_to do |format|
      format.json { render :json => val }
    end
  end
  
  
  

  
  
  
  
  
  
  #================================================================
  #トーク画面のアタック中のリスト結果を返すAPI
  #受け取るクエリ
  #ユーザーID：user_id
  #================================================================
  def get_oneside_rooms
    #（１）USERがメッセージを送った相手全員のIDを取得
    sql1 = 'SELECT M.id, M.sendfrom_list_id, MIN(M.sendto_list_id) AS sendto_list_id, M.room_id, R.public, R.updated_at FROM messages AS M, rooms AS R WHERE R.id = M.room_id AND M.sendfrom_list_id = ' + params[:user_id] + ' GROUP BY M.sendto_list_id ORDER BY R.updated_at DESC;'
    results = ActiveRecord::Base.connection.select(sql1)
    #（２）双方向でメッセージを送りあった相手全員のIDを取得
    sql2 = 'SELECT DISTINCT sendfrom_list_id FROM messages WHERE sendfrom_list_id IN ( SELECT DISTINCT sendto_list_id FROM messages WHERE sendfrom_list_id = ' + params[:user_id] + ') GROUP BY sendfrom_list_id;'
    mutual_send_users = ActiveRecord::Base.connection.select(sql2)
    
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
      obj = List.select("id, nickname, profile_image1, profile").where('id = ?', result["sendto_list_id"]).first
      val.push({
        :sendto_id => obj["id"],
        :nickname => obj["nickname"], 
        :profile_image => obj["profile_image1"], 
        :profile => obj["profile"], 
        :room_updated => exchangeTime( result["updated_at"].to_time ), 
        :room_public => result["public"], 
        :room_id => result["room_id"]
      })
    end
    
    respond_to do |format|
      format.json { render :json => val }
    end
    
  end
  
  
  
  
  
  
  
  
  
  #================================================================
  #トーク画面のトーク中のリスト結果を返すAPI
  #受け取るクエリ
  #ユーザーID：user_id
  #================================================================
  def get_bothside_rooms

    rooms = Arel::Table.new(:rooms, :as => 'rooms')#Arel::Table.new(:rooms)
    messages = Arel::Table.new(:messages, :as => 'messages')#Arel::Table.new(:messages)

    #このユーザーがメッセージを送った相手のユニークなルームIDリスト
    sendtoLists =  messages.
                   project(messages[:room_id]).
                   where(messages[:sendto_list_id].eq(params[:user_id])).
                   group(messages[:room_id]).
                   order(messages[:id].desc) 

    query = messages.
            join(rooms).
            on(messages[:room_id].eq(rooms[:id])).
            project(messages[:id],
                    messages[:sendfrom_list_id],
                    messages[:sendto_list_id],
                    messages[:room_id],
                    rooms[:public],
                    rooms[:updated_at]
            ).
            where(messages[:room_id].in(sendtoLists)).
            where(messages[:sendfrom_list_id].eq(params[:user_id])).
            group(messages[:room_id]).
            order(messages[:id].desc)
            
    sql = query.to_sql
    logger.info("============================")
    logger.info(sql)
    
    #双方向でメッセージを送りあった相手全員のIDを取得
    results = ActiveRecord::Base.connection.select(sql)
    
    val = []
    
    #ハッシュ配列を整形
    results.each do |result|
      nickname, profile_image, profile = nil
      obj = List.select("id, nickname, profile_image1, profile").where('id = ?', result["sendto_list_id"]).first
      val.push({
        :sendto_id => obj["id"],
        :nickname => obj["nickname"], 
        :profile_image => obj["profile_image1"], 
        :profile => obj["profile"], 
        :room_updated => result["updated_at"], 
        :room_public => result["public"], 
        :room_id => result["room_id"]
      })
    end
    
    respond_to do |format|
      format.json { render :json => val }
    end
    
  end
  
  
  
  
  
  
  
  
  #================================================================
  #あるユーザーの詳細画面
  #受け取るクエリ
  #ユーザーID：user_id
  #================================================================
  def get_detail_profile
    result = List.
             where('id = ?', params[:user_id]).
             select("id, 
                    nickname, 
                    profile_image1, 
                    profile_image2, 
                    profile_image3, 
                    age, 
                    area, 
                    purpose, 
                    profile, 
                    tall, 
                    blood, 
                    style, 
                    holiday, 
                    alcohol, 
                    cigarette, 
                    salary").first
    
    val = []
    val.push({
        :id => result["id"], 
        :nickname => result["nickname"], 
        :profile_image1 => result["profile_image1"], 
        :profile_image2 => result["profile_image2"], 
        :profile_image3 => result["profile_image3"], 
        :age => result["age"], 
        :area => result["area"], 
        :purpose => result["purpose"], 
        :profile => result["profile"], 
        :tall => result["tall"], 
        :blood => result["blood"], 
        :style => result["style"], 
        :holiday => result["holiday"], 
        :alcohol => result["alcohol"], 
        :cigarette => result["cigarette"], 
        :salary => result["salary"]
      })
    
    respond_to do |format|
      format.json { render :json => val }
    end
  end
  
  
  
  
  
  
  
  
  #================================================================
  #あるユーザーのルームリストを返す
  #受け取るクエリ
  #ユーザーID：user_id
  #ログインユーザーID：login_user_id
  #================================================================
  def get_user_rooms
    
    rooms = Arel::Table.new(:rooms, :as => 'rooms')
    messages = Arel::Table.new(:messages, :as => 'messages')
    
    query = rooms.
            join(messages).
            on(messages[:room_id].eq(rooms[:id])).
            project(rooms[:id],
                    rooms[:public],
                    rooms[:updated_at],
                    messages[:room_id],
                    messages[:sendfrom_list_id],
                    messages[:sendto_list_id],
                    messages[:body]
            ).
            where(rooms[:public].eq(TRUE)).
            where(messages[:sendfrom_list_id].eq(params[:user_id]).or(messages[:sendto_list_id].eq(params[:user_id]))).
            where(messages[:sendfrom_list_id].not_eq(params[:login_user_id]).and(messages[:sendto_list_id].not_eq(params[:login_user_id]))).
            group(messages[:room_id]).
            order(rooms[:updated_at].desc).
            take(10)
            
    sql = query.to_sql
    logger.info("============================")
    logger.info(sql)
    
    #sql = 'SELECT MIN(R.id), R.public, R.updated_at, M.room_id, M.sendfrom_list_id, M.sendto_list_id, M.body FROM rooms AS R, messages AS M WHERE R.public = "t" AND M.room_id = R.id AND ( M.sendfrom_list_id = ' + params[:user_id] + ' OR M.sendto_list_id = ' + params[:user_id] + ' ) GROUP BY M.room_id ORDER BY R.updated_at DESC LIMIT 10;'
    results = ActiveRecord::Base.connection.select(sql)
    
    val = []
    
    #ハッシュ配列を整形
    results.each do |result|
      sendfrom_image, sendto_image, sendto_message = nil
      obj1 = List.select(:profile_image1).where('id = ?', result["sendfrom_list_id"]).first
      sendfrom_image = obj1["profile_image1"]
      obj2 = List.select(:profile_image1).where('id = ?', result["sendto_list_id"]).first
      sendto_image = obj2["profile_image1"]
      obj3 = Message.select(:body).where('sendfrom_list_id = ?', result["sendto_list_id"]).order('id DESC').first
      updatedtime = exchangeTime(result["updated_at"].to_time)
      
      #もし相手がメッセージ未返信だった場合を想定
      if obj3 then
        sendto_message = obj3["body"]
      else
        sendto_message = ""
      end
      
      val.push({
        :room_id => result["room_id"], 
        :updated_at => updatedtime, #result["updated_at"], 
        :sendfrom_id => result["sendfrom_list_id"],
        :sendfrom_image => sendfrom_image, 
        :sendfrom_message => result["body"], 
        :sendto_image => sendto_image, 
        :sendto_message => sendto_message
      })
    end
    
    respond_to do |format|
      format.json { render :json => val }
    end
  end
  
    
    
    
    
    
    
  #================================================================
  #sendfromIDとsendtoIDからroomIDとメッセージのハッシュ配列を降順に取得
  #受け取るクエリ
  #送信者ID：sendfrom
  #受信者ID：sendto
  #================================================================
  def get_room_message
    sendto_lists = Arel::Table.new(:lists, :as => 'sendto_lists')
    sendfrom_lists = Arel::Table.new(:lists, :as => 'sendfrom_lists')
    messages = Arel::Table.new(:messages, :as => 'messages')
    
    query = messages.
            join(sendfrom_lists).
            on(messages[:sendfrom_list_id].eq(sendfrom_lists[:id])).
            join(sendto_lists).
            on(messages[:sendto_list_id].eq(sendto_lists[:id])).
            project(messages[:id],
                    messages[:room_id],
                    messages[:sendfrom_list_id],
                    sendfrom_lists[:profile_image1].as('sendfrom_image'),
                    messages[:sendto_list_id],
                    sendto_lists[:profile_image1].as('sendto_image'), 
                    messages[:body],
                    messages[:created_at]
            ).
            where(messages[:sendfrom_list_id].eq(params[:sendfrom]).or(messages[:sendfrom_list_id].eq(params[:sendto]))).
            where(messages[:sendto_list_id].eq(params[:sendfrom]).or(messages[:sendto_list_id].eq(params[:sendto]))).
            order(messages[:id].desc).
            take(10)
            
    sql = query.to_sql
    logger.info("============================")
    logger.info(sql)
    
    results = ActiveRecord::Base.connection.select(sql)
    
    val = []
    
    #ハッシュ配列を整形
    results.each do |result|
      logger.info("=======================")
      logger.info(result["created_at"].year)
      logger.info(result["created_at"].month)
      logger.info(result["created_at"].day)
      logger.info(result["created_at"].hour)
      logger.info(result["created_at"].min)
      val.push({
        :id => result["id"],
        :room_id => result["room_id"],
        :sendfrom_list_id => result["sendfrom_list_id"],
        :sendfrom_image => result["sendfrom_image"],
        :sendto_list_id => result["sendto_list_id"],
        :sendto_image => result["sendto_image"],
        :body => result["body"],
        :year => sprintf('%04d', result["created_at"].year),
        :month => sprintf('%02d', result["created_at"].month),
        :day => sprintf('%02d', result["created_at"].day),
        :hour => sprintf('%02d', result["created_at"].hour),
        :min => sprintf('%02d', result["created_at"].min)
      })
    end
      
    respond_to do |format|
      format.json { render :json => val }
    end
  end
    
    
    
    
    
    
    
  #================================================================
  #その他の一言の内容を更新
  #================================================================
  def update_profile

    id = params[:user_id]
    profile = params[:profile]
     
    logger.info("ID===========")
    logger.info(params[:user_id])
    logger.info("Profile===========")
    logger.info(params[:profile])
    
    @list = List.find(id)
  
    respond_to do |format|
      if @list.update_attribute(:profile, profile)
        format.json { render :json => @list.profile, :status => 200 }
      else
        format.json { render :json => @list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  
  
  
  
  
  #================================================================
  #その他のプロフィール編集の内容を更新
  #================================================================
  
  def update_detail_profile
     
    logger.info("ID:#{params[:user_id]}")
    logger.info("NICKNAME:#{params[:nickname]}")
    logger.info("AGE:#{params[:age]}")
    logger.info("PURPOSE:#{params[:purpose]}")
    logger.info("AREA:#{params[:area]}")
    logger.info("TALL:#{params[:tall]}")    
    logger.info("BLOOD:#{params[:blood]}")    
    logger.info("STYLE:#{params[:style]}")
    logger.info("HOLIDAY:#{params[:holiday]}")
    logger.info("ALCOHOL:#{params[:alcohol]}")
    logger.info("CIGARETTE:#{params[:cigarette]}")
    logger.info("SALARY:#{params[:salary]}")

    @list = List.find(params[:user_id])
  
    respond_to do |format|
      if @list.update_attributes(:nickname => params[:nickname],
                                 :age => params[:age],
                                 :purpose => params[:purpose],
                                 :area => params[:area],
                                 :tall => params[:tall],
                                 :blood => params[:blood],
                                 :style => params[:style],
                                 :holiday => params[:holiday],
                                 :alcohol => params[:alcohol],
                                 :cigarette => params[:cigarette],
                                 :salary => params[:salary])
        format.json { render :json => @list, :status => 200 }
      else
        format.json { render :json => @list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  
  
  
  
  
 #================================================================
 #トークで送信されたメッセージを登録
 #================================================================
  def create_message

    logger.info("Message===========")
    logger.info(params[:body])
    logger.info(params[:sendto_list_id])
    logger.info(params[:sendfrom_list_id])
    
    messages = Arel::Table.new(:messages, :as => 'messages')
    #sendfrom_lists = Arel::Table.new(:lists, :as => 'sendfrom_lists')
    
    query = messages.
            #join(sendfrom_lists).
            #on(messages[:sendfrom_list_id].eq(sendfrom_lists[:id])).
            project(messages[:id],
                    messages[:room_id],
                    messages[:sendfrom_list_id],
                    #sendfrom_lists[:profile_image1].as('sendfrom_image'),
                    messages[:sendto_list_id]                    
            ).
            where(messages[:sendfrom_list_id].eq(params[:sendfrom_list_id]).or(messages[:sendfrom_list_id].eq(params[:sendto_list_id]))).
            where(messages[:sendto_list_id].eq(params[:sendfrom_list_id]).or(messages[:sendto_list_id].eq(params[:sendto_list_id]))).
            order(messages[:id].desc).
            take(1)
            
    sql = query.to_sql
    logger.info("============================")
    logger.info(sql)
    
    result = ActiveRecord::Base.connection.select(sql)
    sender = List.find(params[:sendfrom_list_id], :select => "gender")


    if result.count < 1 then
      
      #レコードが一つもないので、新しくroomsモデルにroomを作成
      @room = Room.new
      @room.public = TRUE
      @room.message_number = 0
      if sender.gender == "male" then
        @room.male_id = params[:sendfrom_list_id]
        @room.female_id = params[:sendto_list_id]
      else
        @room.male_id = params[:sendto_list_id]
        @room.female_id = params[:sendfrom_list_id]
      end
      @room.save
      
      @message = Message.new
      @message.sendfrom_list_id = params[:sendfrom_list_id]
      @message.sendto_list_id = params[:sendto_list_id]
      @message.room_id = @room.id
      @message.body = params[:body]
      
      #@room_number = @room.id
      sendfrom_profile_image = List.select(:profile_image1).where('id = ?', params[:sendfrom_list_id]).first
      @sendfrom_image = sendfrom_profile_image["profile_image1"]
       
    else
      #レコードがある場合
      
      @message = Message.new
      @message.sendfrom_list_id = params[:sendfrom_list_id]
      @message.sendto_list_id = params[:sendto_list_id]
      @message.room_id = result[0]["room_id"]
      @message.body = params[:body]
      
      #logger.info("params[:sendfrom_list_id]:#{params[:sendfrom_list_id]}")
      #logger.info("result[0]['sendfrom_list_id']:#{result[0]['sendfrom_list_id']}")
      if result[0]["sendfrom_list_id"] == params[:sendfrom_list_id].to_i then
        obj = List.find(result[0]["sendfrom_list_id"])
      else
        #resultsはルームの最後のメッセージなので、相手が最後にメッセージを送ったときの場合
        obj = List.find(result[0]["sendto_list_id"])
      end
      @sendfrom_image = obj["profile_image1"]
      #logger.info("@sendfrom_image:#{@sendfrom_image}")
      #logger.info("obj['profile_image1']:#{obj['profile_image1']}")
      
    end
    
    respond_to do |format|
      if @message.save
        if result.count < 1 then
          if sender.gender == "male" then
            logger.info("MESSAGE ID: #{@message.id}")
            @room.update_attributes(:male_last_message => @message.id, :updated_at => Time.now.utc, :message_number => @room.message_number + 1)
          elsif sender.gender == "female" then
            logger.info("MESSAGE ID: #{@message.id}")
            @room.update_attributes(:female_last_message => @message.id, :updated_at => Time.now.utc, :message_number => @room.message_number + 1)
          end
        else
          room = Room.find(result[0]["room_id"])
          if sender.gender == "male" then
            logger.info("MESSAGE ID: #{@message.id}")
            room.update_attributes(:male_last_message => @message.id, :updated_at => Time.now.utc, :message_number => room.message_number + 1)
          elsif sender.gender == "female" then
            logger.info("MESSAGE ID: #{@message.id}")
            room.update_attributes(:female_last_message => @message.id, :updated_at => Time.now.utc, :message_number => room.message_number + 1)
          end
        end
        
        
        val = []
        val.push({
        :sendfrom_list_id => @message.sendfrom_list_id,
        :sendfrom_image => @sendfrom_image,
        :sendto_list_id => @message.sendto_list_id,
        :room_id => @message.room_id,
        :body => @message.body,
        :year => sprintf('%04d', @message.created_at.year),
        :month => sprintf('%02d', @message.created_at.month),
        :day => sprintf('%02d', @message.created_at.day),
        :hour => sprintf('%02d', @message.created_at.hour),
        :min => sprintf('%02d', @message.created_at.min)
       })
        
        format.json { render :json => val, :status => 200 }
      else
        format.json { render :json => @message.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  
  
  
  
  #================================================================
  #アカウントを作成
  #================================================================
  def create_account

    logger.info("===========Create Account===========")
    logger.info(params[:channel])
    logger.info(params[:fb_uid])
    logger.info(params[:nickname])
    logger.info(params[:gender])
    logger.info(params[:email])
    logger.info(params[:age])
    logger.info(params[:purpose])
    logger.info(params[:area])
    logger.info(params[:profile_image1])
    logger.info(params[:profile])
    logger.info(params[:point])
      
    @list = List.new
    @list.channel = params[:channel]
    @list.fb_uid = params[:fb_uid]
    @list.nickname = params[:nickname]
    @list.gender = params[:gender]
    @list.email = params[:email]
    @list.age = params[:age]
    @list.purpose = params[:purpose]
    @list.area = params[:area]
    @list.profile_image1 = params[:profile_image1]
    @list.profile = params[:profile]
    @list.point = params[:point]
    @list.last_logined = Time.now.utc
    
    respond_to do |format|
      if @list.save       
        format.json { render :json => @list, :status => 200 }
      else
        format.json { render :json => @list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  
  
  
  
=begin
  #================================================================
  #Facebookから取得したfriends Listを登録
  #================================================================
  def create_friends
    #logger.info("パラメータの中身 :#{params[:friends_list]}")
    
    #@friend = Friend.new(params[:friend])
    respond_to do |format|
      if @friend.save
        format.html { redirect_to @friend, :notice => 'Friend was successfully created.' }
        format.json { render :json => @friend, :status => :created, :location => @friend }
      else
        format.html { render :action => "new" }
        format.json { render :json => @friend.errors, :status => :unprocessable_entity }
      end
    end
  end
=end
  
  
  
  #================================================================
  #Facebookログインボタン押下された際に既に登録されているかチェック
  #================================================================
  def check_login
    logger.info(params[:fb_uid])
    
    flag = List.where(:fb_uid => params[:fb_uid]).exists?
    logger.info("存在するか？ :#{flag}")
    
    respond_to do |format|
      format.json { render :json => flag }
    end
  end
  
  
  
  
  
  #================================================================
  #時間を「〜分前」に変換するメソッド
  #================================================================
  def exchangeTime(time)
    #現在時刻の取得
    now = Time.now.utc
    logger.info(now)
      
    lastlogined = time
      
    seconds = now - lastlogined
    minutes = seconds / 60
      
    if minutes < 1 then
      timetext = "1分以内"
    elsif minutes < 60 then
      timetext = minutes.round.to_s + "分前"
      logger.info(timetext)
    else
      hours = minutes / 60
        
      if hours < 24 then
        timetext = hours.round.to_s + "時間前"
        logger.info(timetext)
      else
        days = hours / 24
          
        if days < 7 then
          timetext = days.round.to_s + "日前"
          logger.info(timetext)
        else
          weeks = days / 7
            
          if weeks < 4 then
            timetext = weeks.round.to_s + "週間前"
            logger.info(timetext)
          else
            timetext = "1ヶ月以上前"
            logger.info(timetext)
          end
        end
      end
    end
  return timetext
  end
end