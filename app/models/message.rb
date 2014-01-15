class Message < ActiveRecord::Base
  attr_accessible :body, :room, :send_from, :send_to
  
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
