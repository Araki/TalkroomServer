class Room < ActiveRecord::Base
  attr_accessible :message_number, :public, :updated_at, :male_last_message, :female_last_message
  
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
