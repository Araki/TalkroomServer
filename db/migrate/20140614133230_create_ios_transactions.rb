class CreateIosTransactions < ActiveRecord::Migration
  def change
    create_table :ios_transactions do |t|
      t.string :type
      t.string :product_id
      t.string :transaction_id
      t.datetime :purchase_date
      t.string :bvrs

      t.timestamps
    end
  end
end
