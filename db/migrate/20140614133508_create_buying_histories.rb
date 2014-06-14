class CreateBuyingHistories < ActiveRecord::Migration
  def change
    create_table :buying_histories do |t|
      t.integer :list_id
      t.string :platform
      t.integer :transaction_id

      t.timestamps
    end
  end
end
