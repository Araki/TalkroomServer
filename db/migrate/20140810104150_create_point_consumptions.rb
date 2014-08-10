class CreatePointConsumptions < ActiveRecord::Migration
  def change
    create_table :point_consumptions do |t|
      t.integer :list_id
      t.string :item_type
      t.integer :point_consumption
      t.integer :room_id

      t.timestamps
    end
  end
end
