class IosTransaction < ActiveRecord::Base
  attr_accessible :bvrs, :product_id, :purchase_date, :transaction_id, :purchase_type
end
