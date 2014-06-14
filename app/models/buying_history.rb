class BuyingHistory < ActiveRecord::Base
  attr_accessible :list_id, :platform, :transaction_id
end
