class Message < ActiveRecord::Base
  attr_accessible :body, :room, :send_from, :send_to
  
  #==========
  #アソシエーションの設定
  #==========
  #belongs_to (オブジェクト名, :class_name => 参照先クラス名, :foreign_key => 接続フィールド名)
  belongs_to :sendfrom, :class_name => 'List', :foreign_key => 'sendfrom_list_id'
  belongs_to :sendto, :class_name => 'List', :foreign_key => 'sendto_list_id'
  belongs_to :rooms
  
  #==========
  #バリデーションの設定
  #==========
  validates :send_from,
    :presence => true
    
  validates :send_to,
    :presence => true
  
  validates :room,
    :presence => true
    
  validates :body,
    :presence => true,
    :length => { :maximum => 140 }
    
end
