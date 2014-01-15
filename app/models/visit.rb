class Visit < ActiveRecord::Base
  attr_accessible :visit_at, :visitor
  
  validates :visitor,
    :presence => true
    
  validates :visit_at,
    :presence => true
    
end
