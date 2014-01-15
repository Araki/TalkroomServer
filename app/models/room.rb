class Room < ActiveRecord::Base
  attr_accessible :message_number, :public
  
  validates :public,
    :presence => true
    
  validates :message_number,
    :presence => true
    
end
