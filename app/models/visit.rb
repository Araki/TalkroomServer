class Visit < ActiveRecord::Base
  attr_accessible :visitor_list_id, :visitat_list_id
  
  #==========
  #アソシエーションの設定
  #==========
  #belongs_to (オブジェクト名, :class_name => 参照先クラス名, :foreign_key => 接続フィールド名)
  belongs_to :visitor, :class_name => 'List', :foreign_key => 'visitor_list_id'
  belongs_to :visitat, :class_name => 'List', :foreign_key => 'visitat_list_id'
  
  
  #==========
  #バリデーションの設定
  #==========
  
  validates :visitor_list_id,
    :presence => true
    
  validates :visitat_list_id,
    :presence => true
    
end
