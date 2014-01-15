class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.boolean :public
      t.integer :message_number

      t.timestamps
    end
  end
end
