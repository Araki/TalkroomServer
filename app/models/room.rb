class Room < ActiveRecord::Base
  attr_accessible :message_number, :public
  
  #==========
  #アソシエーションの設定
  #==========
  has_many :messages
  
  
  #==========
  #バリデーションの設定
  #==========
  
  # validates :public,
    
  validates :message_number,
    :presence => true
    
end
