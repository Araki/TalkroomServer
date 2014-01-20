class Message < ActiveRecord::Base
  attr_accessible :body, :room_id, :sendfrom_list_id, :sendto_list_id
  
  #==========
  #アソシエーションの設定
  #==========
  #belongs_to (オブジェクト名, :class_name => 参照先クラス名, :foreign_key => 接続フィールド名)
  belongs_to :sendfrom, :class_name => 'List', :foreign_key => 'sendfrom_list_id'
  belongs_to :sendto, :class_name => 'List', :foreign_key => 'sendto_list_id'
  belongs_to :room
  
  #==========
  #バリデーションの設定
  #==========
  validates :sendfrom_list_id,
    :presence => true
    
  validates :sendto_list_id,
    :presence => true
  
  validates :room_id,
    :presence => true
    
  validates :body,
    :presence => true,
    :length => { :maximum => 140 }
    
end
