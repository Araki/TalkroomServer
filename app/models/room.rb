class Room < ActiveRecord::Base
  attr_accessible :message_number, :public
  
  # validates :public,
    
  validates :message_number,
    :presence => true
    
end
