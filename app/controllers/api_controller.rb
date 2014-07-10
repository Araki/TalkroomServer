class ApiController < ApplicationController
  
  # 認証フィルタ
  #   認証が必要なAPIを only に追加すること
  #   認証を終えると変数 @user にユーザ情報が格納されるため、各処理で利用できる
  #   例) before_filter :check_app_token, :only => [:create_message, :create_friends]
  before_filter :check_app_token, :only => [:example_token,
                                            :get_all_users,
                                            :get_recent_rooms,
                                            :get_room_summary_data,
                                            :get_search_users,
                                            :get_oneside_rooms,
                                            :get_bothside_rooms,
                                            :get_detail_profile,
                                            :get_user_rooms,
                                            :get_room_message,
                                            :update_profile,
                                            :update_detail_profile,
                                            :create_message,
                                            :get_visits,
                                            :send_mail,
                                            :verify_receipt,
                                            :get_point,
                                            :consume_point,
                                            :change_private_room,
                                            :upload_image
                                            #:create_account
                                            ]
  
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
    
    sql = query.to_sql
    logger.info(sql)

    results = ActiveRecord::Base.connection.select(sql) 
    

    val = []

    results.each do |result|
      logger.info(result)

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
    
    access_user = List.find(@user.id, :select => "gender")
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
    rooms = Arel::Table.new(:rooms, :as => 'rooms')#Arel::Table.new(:rooms)
    messages = Arel::Table.new(:messages, :as => 'messages')#Arel::Table.new(:messages)

    #このユーザーがメッセージを送った相手のユニークなルームIDリスト
    sendtoLists =  messages.
                   project(messages[:room_id]).
                   where(messages[:sendto_list_id].eq(@user.id)).
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
            where(messages[:room_id].not_in(sendtoLists)).
            where(messages[:sendfrom_list_id].eq(@user.id)).
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
                   where(messages[:sendto_list_id].eq(@user.id)).
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
            where(messages[:sendfrom_list_id].eq(@user.id)).
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
  #足あとリストの取得
  #受け取るクエリ
  #なし
  #================================================================   
  def get_visits
    visits = Arel::Table.new(:visits, :as => 'visits')
    lists = Arel::Table.new(:lists, :as => 'lists')
    
    query = visits.
            join(lists).
            on(visits[:visitor_list_id].eq(lists[:id])).
            project(lists[:id],
                    lists[:nickname],
                    lists[:profile_image1],
                    lists[:profile],
                    lists[:area],
                    lists[:purpose],
                    visits[:updated_at]
            ).
            where(visits[:visitat_list_id].eq(@user.id)).
            order(visits[:updated_at].desc).
            take(10)
            
    sql = query.to_sql
    
    results = ActiveRecord::Base.connection.select(sql)
  
    val = []
    
    results.each do |result|
      val.push({
        :id => result["id"],
        :nickname => result["nickname"],
        :profile_image1 => result["profile_image1"],
        :profile => result["profile"],
        :area => result["area"], 
        :purpose => result["purpose"],
        :updated_at => exchangeTime(result["updated_at"].to_time)
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
    
 #===================
 #visitsテーブルに記録
 #===================
    
    if @user.id.to_s != params[:user_id] then
      
      duplication = Visit.
                    where('visitor_list_id = ?', @user.id).
                    where('visitat_list_id = ?', params[:user_id]).
                    first
      
      if Visit.exists?(duplication) then
        logger.info("EXIST!!!!!")
        duplication.update_attribute(:updated_at, Time.now.utc)
      else
        logger.info("NOT EXIST!!!!!!!!")
        @visit = Visit.new
        @visit.visitor_list_id = @user.id
        @visit.visitat_list_id = params[:user_id]
        @visit.save
      end
      
    end
    
 
 #===================
 #メイン処理
 #===================    
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
            where(male_lists[:id].eq(params[:user_id]).or(female_lists[:id].eq(params[:user_id]))).
            where(male_lists[:id].not_eq(@user.id).and(female_lists[:id].not_eq(@user.id))).
            order(rooms[:updated_at].desc)  
            
    sql = query.to_sql
    logger.info("============================")
    logger.info(sql)
    results = ActiveRecord::Base.connection.select(sql)
    
    val = []
    
    #ハッシュ配列を整形
    results.each do |result|
      val.push({
        :room_id => result["room_id"], 
        :updated_at => exchangeTime(result["updated_at"].to_time),
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
  #ユーザーのポイントを取得
  #================================================================
  def get_point
    result = List.find(@user.id)
    respond_to do |format|
      format.json { render :json => result.point }
    end
  end
    
  #================================================================
  #ユーザーのポイントを消費
  #================================================================
  def consume_point
    before_point = @user.point
    after_point = before_point - params[:consume_point].to_i
     
    respond_to do |format|
      if @user.update_attribute(:point, after_point)
        format.json { render :json => @user.point, :status => 200 }
      else
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
   end

  #================================================================
  #ルームをプライベートに
  #受け取るクエリ
  #ルームID：room_id
  #================================================================
   def change_private_room
     @room = Room.find(params[:room_id])
     respond_to do |format|
       if @room.update_attribute(:public, FALSE)
         format.json { render :json => @room.public, :status => 200 }
       else
         format.json { render :json => @room.errors, :status => :unprocessable_entity }
       end
     end
   end
    
    
    
    
  #================================================================
  #その他の一言の内容を更新
  #================================================================
  def update_profile

    id = @user.id
    profile = params[:profile]
     
    logger.info("ID===========")
    logger.info(@user.id)
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
     
    logger.info("ID:#{@user.id}")
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

    @list = List.find(@user.id)
  
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
    logger.info(@user.id)
    
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
            where(messages[:sendfrom_list_id].eq(@user.id).or(messages[:sendfrom_list_id].eq(params[:sendto_list_id]))).
            where(messages[:sendto_list_id].eq(@user.id).or(messages[:sendto_list_id].eq(params[:sendto_list_id]))).
            order(messages[:id].desc).
            take(1)
            
    sql = query.to_sql
    logger.info("============================")
    logger.info(sql)
    
    result = ActiveRecord::Base.connection.select(sql)
    sender = List.find(@user.id, :select => "gender")


    if result.count < 1 then
      
      #レコードが一つもないので、新しくroomsモデルにroomを作成
      @room = Room.new
      @room.public = TRUE
      @room.message_number = 0
      if sender.gender == "male" then
        @room.male_id = @user.id
        @room.female_id = params[:sendto_list_id]
      else
        @room.male_id = params[:sendto_list_id]
        @room.female_id = @user.id
      end
      @room.save
      
      @message = Message.new
      @message.sendfrom_list_id = @user.id
      @message.sendto_list_id = params[:sendto_list_id]
      @message.room_id = @room.id
      @message.body = params[:body]
      
      #@room_number = @room.id
      sendfrom_profile_image = List.select(:profile_image1).where('id = ?', @user.id).first
      @sendfrom_image = sendfrom_profile_image["profile_image1"]
       
    else
      #レコードがある場合
      
      @message = Message.new
      @message.sendfrom_list_id = @user.id
      @message.sendto_list_id = params[:sendto_list_id]
      @message.room_id = result[0]["room_id"]
      @message.body = params[:body]
      
      #logger.info("params[:sendfrom_list_id]:#{params[:sendfrom_list_id]}")
      #logger.info("result[0]['sendfrom_list_id']:#{result[0]['sendfrom_list_id']}")
      if result[0]["sendfrom_list_id"] == @user.id then
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
  #画像をアップロード
  #================================================================
  
  def upload_image
    AWS.config(
      :access_key_id => 'AKIAIF2RBQ4WNU3KWKMQ', 
      :secret_access_key => '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', 
      :region => 'us-east-1'
    )
    s3 = AWS::S3.new #S3オブジェクトの生成
    bucket = s3.buckets['talkroom-profile'] #bucketの指定
    file = params[:media]
    logger.info("Params[:media]:#{file.tempfile}")
    file_name = file.original_filename
    file_full_path = "images/" + file_name
    logger.info("original_filename:#{file.original_filename}")
    object = bucket.objects[file_full_path] #objectというオブジェクトの作成
    
    url = "http://ww1.sinaimg.cn/large/9a95b0aagw1e6d5mhmmcjj20uc1a1wp8.jpg"
    image = Net::HTTP.get_response(URI.parse(url)).body
    #logger.info("IMG:#{image}")
    
    object.write(image, {:acl => :public_read}) #作成したobjectをs3にファイルを保存
    #画像ファイルパスの格納
    file_url = "https://s3-ap-northeast-1.amazonaws.com/talkroom-profile/images/#{file_name}"
    
    respond_to do |format|
      if @user.update_attribute(:profile_image2, file_url)
        format.json { render :json => "success", :status => 200 }
      else
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  
  
  #================================================================
  #アカウントを作成
  #================================================================
  def create_account
    
    # access_token チェック
    if Digest::MD5.hexdigest(Digest::MD5.hexdigest(params[:fb_uid])) != params[:access_token] 
      # 異なるときはエラー
      respond_to do |format|
        format.json { render :json => {:error => "Invalid Access Token", :status => 403 }}
      end
    else
      
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
    
      # セキュリティ向上のためのトークンを生成
      # （ここで生成された値をスマートフォン側に保存しておく必要あり）
      @list.app_token = params[:fb_uid] + "-" + Digest::MD5.hexdigest(params[:fb_uid] + Time.now.to_s)
    
      respond_to do |format|
        if @list.save       
          format.json { render :json => @list, :status => 200 }
        else
          format.json { render :json => @list.errors, :status => :unprocessable_entity }
        end
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
  # すでに登録されているときは、認証用のapp_tokenを返却
  #================================================================
  def check_login
    logger.info(params[:fb_uid])
    logger.info(params[:access_token])
    
    flag = List.where(:fb_uid => params[:fb_uid]).exists?
    logger.info("存在するか？ :#{flag}")
    
    # access_token をチェック
    # access_token 生成アルゴリズムをスマホ側と共有する必要あり
    #   今回は fb_uid をシードに2回MD5関数をとったものとする
    if( flag == true && Digest::MD5.hexdigest(Digest::MD5.hexdigest(params[:fb_uid])) == params[:access_token] )
      logger.info("Check access token : Success")
      
      # ユーザ検索
      user = List.find_by_fb_uid params[:fb_uid]
      app_token = user.app_token
      user_id = user.id
      flag = "true"
      
      user.update_attribute(:last_logined, Time.now.utc)
      
    else
      logger.info("Check access token : Failure")
      flag = "false"
      app_token = nil 
    end
    
    respond_to do |format|
      format.json { render :json => {:result => flag, :app_token => app_token, :user_id => user_id} }
    end
  end
  
  #================================================================
  # レシートを受け取り，検証し，DBに保存する
  #================================================================
  def verify_receipt
    data = params[:receipt]
    
    isError = false
    @result = {   # 成功時の返却値
      :code => 0,
      :message => ''
    }
    
    begin
      receipt = Venice::Receipt.verify!(data)
      receipt_detail = receipt.to_h
      
      # トランザクションによるデータ一貫性保護
      ActiveRecord::Base.transaction do
        transaction = IosTransaction.new({
          :purchase_type => 'consumable',
          :product_id => receipt_detail[:product_id],
          :transaction_id => receipt_detail[:transaction_id],
          :purchase_date => receipt_detail[:purchase_date],
          :bvrs => receipt_detail[:bvrs]
        })
        transaction.save!
        
        history = BuyingHistory.new({
          :list_id => @user.id,
          :platform => 'ios',
          :transaction_id => transaction.id
        })
        history.save!
        
        case receipt_detail[:product_id]
        when "jp.shiftage.talkroom.testpoint100" then
          point = 100
        when "jp.shiftage.talkroom.testpoint300" then
          point = 300
        when "jp.shiftage.talkroom.testpoint500" then
          point = 500
        end
        @list = List.find(@user.id)
        @list.update_attribute(:point, @list.point + point)
        
      end
      
    rescue ActiveRecord::RecordNotUnique => e
      # 重複行エラー
      isError = false #エラーとしない
      @result = {
        :code => 0,
        :message => ''
      }
    rescue Venice::Receipt::VerificationError => e
      # Receipt に関するエラーが発生したとき
      isError = true 
      @result = {
        :code => e.code,
        :message => e.message
      }
    rescue => e
      # 未知のエラーが発生したとき
      isError = true 
      @result = {
        :code => 9,            # 未知のエラーのときは 9 とする
        :message => e.message
      }
    end
    
    respond_to do |format|
      if isError == false
        format.json { render :json => @list.point, :status => 200 }
      else
        format.json { render :json => @result, :status => :unprocessable_entity }
      end
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
  
  # app_token をもとに認証する
  def check_app_token 
    app_token = params[:app_token]
    @user = List.find_by_app_token(app_token)
    logger.info("AppToken-UserID :#{@user}")
    # app_token にひもづくユーザーが見つからなかったときはエラー
    if @user == nil
      logger.info("AppToken-UserID :NULL")
      respond_to do |format|
        format.json { render :json => {:error => 'Auth error'} }
      end
    end
  end
  
  # token 利用の例
  def example_token
    # ここにきた時点ですでに before_filter の check_app_token をチェック済みのはず
    # 認証されたユーザ情報は インスタンス変数 @user に格納されています
    respond_to do |format|
      format.json { render :json => {:result => 'OK', :user => @user.id }}
    end
  end
  
  #================================================================
  #CAリワード用のポイントバックAPI
  #================================================================
  #正常に完了した場合にはレスポンスBODY部に“OK”[半角大文字2文字]を返却
  #広告ID × 会員ID × 成果発生日時 × 成果地点IDの条件でポイントバック通知の重複チェック
  #
  def car_pointback
    
    remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
    logger.info("IP Address :#{remote_ip}")
    
    if remote_ip == "202.234.38.240" || remote_ip =="59.106.126.70" || remote_ip =="59.106.126.73" || remote_ip == "59.106.126.74" then
      logger.info("$$$$$$$$$$$$$$$$$$$$$$$")
      
      @ca_reward = Ca_reward.new
      @ca_reward.list_id = params[:list_id]
      @ca_reward.cid = params[:cid]
      @ca_reward.cname = params[:cname]
      @ca_reward.carrier = params[:carrier]
      @ca_reward.click_date = params[:click_date]
      @ca_reward.action_date = params[:action_date]
      @ca_reward.commision = params[:commision]
      @ca_reward.aff_id = params[:aff_id]
      @ca_reward.point = params[:point]
    
      respond_to do |format|
        if @ca_reward.save       
          #format.html { render :text => "OK" }
          format.json { render :json => {:body => "OK"}}
        else
          #format.html { render :text => "NG" }
          format.json { render :json => {:body => "NG"}}
        end
      end
    else
      respond_to do |format|
        #format.html { render :text => "NG"}
        format.json { render :json => {:body => "NG"}}
      end
    end
  end
  
  
  
  
  def send_mail
    # SSL/TLSを有効に
    require 'tlsmail'
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
    
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.smtp_settings = {
      :address => 'smtp.gmail.com',
      :port => 587,
      :domain => 'mail.gmail.com',
      :authentication => :plain,
      :user_name => 'araki@shiftage.jp',#'admin@talkroom.co',
      :password => 'bradpitt'#'Pairful1001'
    }
    
    @inquiry = Inquiry.new
    @inquiry.list_id = @user.id
    @inquiry.platform = params[:platform]
    @inquiry.version = params[:version]
    @inquiry.manufacturer = params[:manufacturer]
    @inquiry.model = params[:model]
    @inquiry.address = params[:mail]
    @inquiry.body = params[:body]
  
    respond_to do |format|
      if @inquiry.save       
        mail = InquiryMailer.sendmail_confirm(@inquiry.id,
                                              params[:platform], 
                                              params[:version], 
                                              params[:manufacturer],
                                              params[:model],
                                              params[:mail], 
                                              params[:body]).deliver
        format.json{ render :text => "OK" }
      else
        format.json { render :json => @list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
end
