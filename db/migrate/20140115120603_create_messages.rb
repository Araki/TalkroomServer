class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :send_from
      t.integer :send_to
      t.integer :room
      t.string :body

      t.timestamps
    end
  end
end
