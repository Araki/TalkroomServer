class Visit < ActiveRecord::Base
  attr_accessible :visit_at, :visitor
  
  #==========
  #アソシエーションの設定
  #==========
  #belongs_to (オブジェクト名, :class_name => 参照先クラス名, :foreign_key => 接続フィールド名)
  belongs_to :visitor, :class_name => 'List', :foreign_key => 'visitor_list_id'
  belongs_to :visitat, :class_name => 'List', :foreign_key => 'visitat_list_id'
  
  
  #==========
  #バリデーションの設定
  #==========
  
  validates :visitor,
    :presence => true
    
  validates :visit_at,
    :presence => true
    
end
