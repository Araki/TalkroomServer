class Message < ActiveRecord::Base
  attr_accessible :body, :room, :send_from, :send_to
end
